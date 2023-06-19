//
//  CommentListRepository.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/06/19.
//

import Foundation
import Combine

protocol CommentListRepositoryType {
    func registerComment(with topicId: Int, comment: String) async -> Void
    func fetchComment(with topicId: Int) async -> Model.CommentList
    func deleteComment(commentId: Int) async -> Void
}

final class CommentListRepository: CommentListRepositoryType {
    private var bag = Set<AnyCancellable>()
    
    func registerComment(with topicId: Int, comment: String) async -> Void {
        return await withCheckedContinuation({ continuation in
            API.RegisterComment(topicID: topicId, comment: comment, userID: Utils.getDeviceUUID())
                .request()
                .print("API.RegisterComment")
                .sink { _ in
                } receiveValue: { _ in
                    continuation.resume(returning: ())
                }.store(in: &bag)
        })
    }
    
    func fetchComment(with topicId: Int) async -> Model.CommentList {
        return await withCheckedContinuation({ continuation in
            API.FetchCommentList(topicID: topicId).request()
                .print("API.FetchCommentList")
                .sink { _ in
                } receiveValue: { comments in
                    continuation.resume(returning: comments)
                }.store(in: &bag)
        })
    }
    
    func deleteComment(commentId: Int) async -> Void {
        return await withCheckedContinuation({ continuation in
            API.DeleteComment(commentID: commentId).request()
                .print("API.DeleteComment")
                .sink { _ in
                } receiveValue: { _ in
                    continuation.resume(returning: ())
                }.store(in: &bag)
        })
    }
}
