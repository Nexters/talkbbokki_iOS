//
//  API+Error.swift
//  talkbbokki
//
//  Created by USER on 2023/02/08.
//

import Foundation
import Combine

protocol APIConfigWithError: APIConfig { }

extension APIConfigWithError {
    func requestWithCatch() -> AnyPublisher<Result<Response, APIError<ServiceError>>, Never> {
        return self.makeRequest()
            .flatMap { response in
                return Just(Result<Response, APIError<ServiceError>>.success(response))
            }
            .catch { error -> AnyPublisher<Result<Response, APIError<ServiceError>>, Never> in
                guard let apiError = error as? APIError<ServiceError> else {
                    return Empty<Result<Response, APIError<ServiceError>>, Never>().eraseToAnyPublisher()
                }

                return Just(Result<Response, APIError<ServiceError>>.failure(apiError))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
