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
    struct Topics {
        let category: String
    }
    struct RecommendOrder { }
    struct Suggest {
        let text: String
    }
    struct Like {
        let topicID: Int
    }
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

extension API.Topics: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/categories/\(category)/topics" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return nil
    }
    
    func parse(_ input: Data) throws -> [Model.Topic] {
        let json   = try? input.toDict()
        let result = (json?["result"] as? Array<[String: Any]>)!
        return try result.map(Model.Topic.decode)
    }
}

extension API.RecommendOrder: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/talk-orders" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return nil
    }
    
    func parse(_ input: Data) throws -> Model.Order {
        let json   = try? input.toDict()
        let result = (json?["result"] as? [String: Any])!
        return try Model.Order.decode(dictionary: result)
    }
}

extension API.Suggest: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/topic-suggestion?text=\(self.text)"}
    var method: HTTPMethod { return .post }
    var parameters: API.Parameter? {
        return nil
    }
    
    func parse(_: Data) throws -> Void {
        return ()
    }
}

extension API.Like: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/topics/\(topicID)/view-count"}
    var method: HTTPMethod { return .post }
    var parameters: API.Parameter? {
        return nil
    }
    
    func parse(_: Data) throws -> Void {
        return ()
    }
}
