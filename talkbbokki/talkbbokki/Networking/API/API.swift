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
    
    struct CommentCount {
        let topicID: Int
    }
    
    struct RegisterComment {
        let topicID: Int
        let comment: String
        let userID: String
        let userNickname: String
    }
    
    struct FetchCommentList {
        let topicID: Int
        let next: Int?
    }
    
    struct DeleteComment {
        let commentID: Int
    }
    
    struct RegisterUser {
        let uuid: String
        let pushToken: String
        let nickName: String
    }
    
    struct ValidNickname {
        let nickName: String
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

extension API.CommentCount: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/topics/\(topicID)/comments/count"}
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? { return nil }
    
    func parse(_ input: Data) throws -> Int {
        let json   = try? input.toDict()
        let result = (json?["result"] as? Int)!
        return result
    }
}

extension API.RegisterComment: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/topics/\(topicID)/comments"}
    var method: HTTPMethod { return .post }
    var parameters: API.Parameter? {
        return .body(
            [
                "body": comment,
                "userId": userID,
            ]
        )
    }
    
    func parse(_ : Data) throws -> Void {
        return ()
    }
}

extension API.FetchCommentList: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String {
        if let next {
            return "/api/topics/\(topicID)/comments?next=\(next)&pageSize=20"
        } else {
            return "/api/topics/\(topicID)/comments?pageSize=20"
        }
    }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? { return nil }
    
    func parse(_ input : Data) throws -> Model.CommentList {
        let json   = try? input.toDict()
        let result = (json?["result"] as? [String: Any])!
        return try Model.CommentList.decode(dictionary: result)
    }
}

extension API.DeleteComment: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/comments/\(commentID)"}
    var method: HTTPMethod { return .delete }
    var parameters: API.Parameter? { return nil }
    
    func parse(_ : Data) throws -> Void {
        return ()
    }
}

extension API.RegisterUser: APIConfig, APIHeaderConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/users"}
    var method: HTTPMethod { return .post }

    var headers: [String : String]? {
        ["Content-Type": "application/hal+json; charset=UTF-8"]
    }
    var parameters: API.Parameter? {
        return .body([
            "uuid": uuid,
            "pushToken": pushToken,
            "nickName": nickName
        ])
    }
    
    func parse(_: Data) throws -> Void {
        return ()
    }
}

extension API.ValidNickname: APIConfig {
    static let domainConfig = Domain.Talkbbokki.self
    static let serviceError = TalkbbokkiError.self
    
    var path: String { return "/api/users/nickname/exists?nickName=\(nickName)"}
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return nil
    }
    
    func parse(_: Data) throws -> Void {
        return ()
    }
}
