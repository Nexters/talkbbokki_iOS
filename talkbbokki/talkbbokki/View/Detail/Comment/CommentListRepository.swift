//
//  CommentListRepository.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/06/19.
//

import Foundation
import Combine

protocol CommentListRepositoryType {
    func registerComment(with topicId: Int, parentCommentId: Int?, comment: String) async -> Void
    func fetchComment(with topicId: Int, next: Int?) async -> Model.CommentList
    func deleteComment(commentId: Int) async -> Void
    func fetchChildComment(with topicId: Int, parentCommentId: Int, next: Int?) async -> Model.CommentList
}

final class CommentListRepository: CommentListRepositoryType {
    private var bag = Set<AnyCancellable>()
    
    func registerComment(with topicId: Int, parentCommentId: Int?, comment: String) async -> Void {
        return await withCheckedContinuation({ continuation in
            API.RegisterComment(topicID: topicId,
                                parentCommentID: parentCommentId,
                                comment: comment,
                                userID: Utils.getDeviceUUID(),
                                userNickname: UserDefaultValue.nickName
            )
                .request()
                .print("API.RegisterComment")
                .sink { _ in
                } receiveValue: { _ in
                    continuation.resume(returning: ())
                }.store(in: &bag)
        })
    }
    
    func fetchComment(with topicId: Int, next: Int?) async -> Model.CommentList {
        return await withCheckedContinuation({ continuation in
            API.FetchCommentList(topicID: topicId, next: next).request()
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

    func fetchChildComment(with topicId: Int, parentCommentId: Int, next: Int?) async -> Model.CommentList {
        return await withCheckedContinuation({ contiuation in
            API.FetchChildCommentList(topicID: topicId, parentCommentId: parentCommentId, next: next).request()
                .print("API.FetchChildCommentList")
                .sink { _ in
                } receiveValue: { comments in
                    contiuation.resume(returning: comments)
                }.store(in: &bag)
        })
    }
}
