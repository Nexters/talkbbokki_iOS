//
//  API.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation
import Alamofire

struct API { }

extension API {
    struct Category { }
}

extension API.Category: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/categories" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return nil
    }
    
    func parse(_ input: Data) throws -> [Model.Category] {
        let json   = try? input.toDict()
        let result = (json?["result"] as? Array<[String: Any]>)!
        return try result.map(Model.Category.decode)
    }
}
