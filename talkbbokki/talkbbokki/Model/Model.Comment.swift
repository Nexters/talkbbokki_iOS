//
//  Model.Comment.swift
//  talkbbokki
//
//  Created by USER on 2023/05/13.
//

import Foundation

extension Model {
    struct CommentList: Codable, Equatable {
        let previous: Int?
        let next: Int?
        let comments: [Model.Comment]
        
        enum CodingKeys: String, CodingKey {
            case previous, next
            case comments = "contents"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Model.CommentList.CodingKeys> = try decoder.container(keyedBy: Model.CommentList.CodingKeys.self)
            self.previous = try container.decodeIfPresent(Int.self, forKey: .previous)
            self.next = try container.decodeIfPresent(Int.self, forKey: .next)
            self.comments = try container.decode([Model.Comment].self, forKey: .comments)
        }
    }
    
    struct Comment: Codable, Equatable {
        let _id: Int
        let topicId: Int
        let parentCommentId: Int?
        let body: String
        let userId: String
        let createAt: String
        let modifyAt: String
        
        var createdToPresent: String {
            createAt.toDate()?.toUTCString() ?? ""
        }
        
        var modifiedToPresent: String {
            modifyAt.toDate()?.toUTCString() ?? ""
        }
    }
}
