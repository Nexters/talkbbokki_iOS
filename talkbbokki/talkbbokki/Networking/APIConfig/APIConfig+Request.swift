//
//  API+Request.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation
import Alamofire
import Combine

extension APIConfig {
    internal func makeRequest() -> Future<Response, APIError<ServiceError>> {
        return Future { future in
            print("\n\n")
            print("********** REQUEST **********")
            print("-fullPath: \(self.fullPath)")
            print("-parameter: \(self.parameters?.params ?? [:])")
            print("*********************************")
            print("\n")

            let request = Self.domainConfig.manager.request(self.fullPath,
                                                            method: self.method,
                                                            parameters: self.fullParameters,
                                                            encoding: self.encoding,
                                                            headers: HTTPHeaders(self.fullHeaders))
            request.validate().responseData(completionHandler: self.responseHandler(future))

        }
    }
}

extension APIConfig {
    private func responseHandler(_ future: @escaping ((Result<Response, APIError<ServiceError>>) -> Void)) -> ((AFDataResponse<Data>) -> Void) {
        return { (response: AFDataResponse<Data>) -> Void in
            switch response.result {
            case .success(let data):
                do {
                    if let description = String(data:data, encoding: .utf8) {
                        print("\n\n")
                        print("********** RESPONSE : \(Self.Response.self) **********")
                        print(description)
                        print("*********************************")
                        print("\n")
                    }
                    
                    let response = try self.parse(data)
                    future(.success(response))
                } catch let error {
                    future(.failure(APIError<ServiceError>.init(code: .inconsistantModelParseFailed,
                                                                message: error.localizedDescription)))
                }
                
            case .failure(let error):
                if let errorDate = response.data {
                    print(String(data: errorDate, encoding: .utf8) ?? "")
                }
                
                future(.failure(failHandler(error: error, response: response)))
            }
            
        }
    }
    
    private func failHandler(error: Error, response: AFDataResponse<Data>) -> APIError<ServiceError> {
        guard error.isCanceled == false else {
            return APIError(code: .opertaionCanceled)
        }
        
        guard let afError = error as? AFError else {
            print("\n\n")
            print("**********  OS ERROR FAIL CODE ********** ")
            print("-error: \(error)")
            print("*********************************")
            print("\n")
            return APIError(code: .networkError)
        }
        
        guard case let .responseValidationFailed(reason: .unacceptableStatusCode(code: status)) = afError else {
            return APIError.init(code: .malformedRequest)
        }
        
        switch status {
        case 503:
            return APIError(code: .serviceExternalUnavailable, status: status, message: afError.localizedDescription)
            
        case (500..<600):
            print("\n\n")
            print("**********  HTTP ERROR FAIL **********")
            print("-HTTP status: \(status)")
            print("*********************************")
            print("\n")
            
            return APIError.init(code: .internalServerError, status: status, message: afError.localizedDescription)
        default:
            guard let data = response.data, let error = try? APIError(data: data, status: status, type: Self.serviceError.self) else {
                return APIError(code: .http, status: nil, message: afError.localizedDescription)
            }
            
            return error
        }
    }
}

extension Future {
    internal func globalException<T: APIConfig>(_ target: T) -> AnyPublisher<Output, Error> {
        return self.handleEvents(receiveOutput:  { data in
            debugPrint("\n\n")
            debugPrint("********** API SUCCESS **********")
            debugPrint("-success: [\(target.method)] \(target.path)")
            debugPrint("-header: \(target.fullHeaders)")
            debugPrint("-parameter: \(target.fullParameters ?? [:])")
            debugPrint("-data: \(data)")
            debugPrint("*********************************")
            debugPrint("\n")
        })
        .tryCatch({ error -> Future<Output, Error> in
            debugPrint("\n\n")
            debugPrint("********** API FAILED **********")
            debugPrint("-success: [\(target.method)] \(target.path)")
            debugPrint("-header: \(target.fullHeaders)")
            debugPrint("-parameter: \(target.fullParameters ?? [:])")
            debugPrint("-errror: \(error)")
            debugPrint("*********************************")
            debugPrint("\n")
            guard let apiError = error as? APIError<T.ServiceError> else { throw error }
            if T.ServiceError.globalException() == true {
                throw APIError<T.ServiceError>.init(code: .globalException, status: apiError.status, message: apiError.message)
            } else {
                throw apiError
            }
        })
        .eraseToAnyPublisher()
    }
}

extension Error {
    fileprivate var isCanceled: Bool {
        return (self as NSError).domain == NSURLErrorDomain && (self as NSError).code == NSURLErrorCancelled
    }
}
