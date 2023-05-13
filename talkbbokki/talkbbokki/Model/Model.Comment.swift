//
//  Model.Comment.swift
//  talkbbokki
//
//  Created by USER on 2023/05/13.
//

import Foundation

extension Model {
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
