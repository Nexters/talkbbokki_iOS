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
    
    func parse(_ input: Data) throws -> Bool {
        let json   = try? input.toDict()
//        let result = (json?["result"] as? Bool)!
        return true
//        return try Model.Letter.decode(dictionary: result)
    }
}
