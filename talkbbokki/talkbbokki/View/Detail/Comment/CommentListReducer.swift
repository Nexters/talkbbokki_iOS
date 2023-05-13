//
//  CommentReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import Combine
import ComposableArchitecture

final class CommentListReducer: ReducerProtocol {
    private var bag = Set<AnyCancellable>()
    
    struct State: Equatable {
        let topicID: Int
        var didLoad = false
        var commentCount: Int = 0
        var inputComment: String = ""
        var deleteCommentId: Int = 0
        var comments: [Model.Comment] = []
        var showDeleteAlert = false
        var tapDeleteAlert: ButtonType = .none
    }
    
    enum Action {
        case setInputComment(String)
        case setDeleteCommentId(Int)
        case registerComment(String)
        case fetchComments
        case setComments([Model.Comment])
        case setShowDeleteAlert(Bool)
        case setTapDeleteAlert(ButtonType)
        case delegate(DelegateAction)
    }
    
    enum DelegateAction: Equatable {
        case changedComment(Int)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .setInputComment(let comment):
            state.inputComment = comment
            return .none
        case .setDeleteCommentId(let id):
            state.deleteCommentId = id
            if id > 0 {
                return .send(.setShowDeleteAlert(true))
            }
            return .none
        case .setShowDeleteAlert(let isShow):
            state.showDeleteAlert = isShow
            return .none
        case .registerComment(let comment):
            return EffectTask.run { [weak self, state = state] operation in
                guard let self = self else { return }
                await self.registerComment(with: state.topicID, comment: comment)
                await operation.send(.fetchComments)
                await operation.send(.setInputComment(""))
            }
        case .fetchComments:
            return EffectTask.run { [weak self, topicID = state.topicID] operation in
                guard let self = self else { return }
                await operation.send(.setComments(self.fetchComment(with: topicID)))
            }
        case .setComments(let comments):
            state.comments = comments
            state.commentCount = comments.count
            state.didLoad = true
            return .send(.delegate(.changedComment(comments.count)))
        case .setTapDeleteAlert(let type):
            state.tapDeleteAlert = type
            if case .ok = type {
                return .run { [weak self, state = state] operation in
                    guard let self = self else { return }
                    await self.deleteComment(commentId: state.deleteCommentId)
                    await operation.send(.fetchComments)
                    await operation.send(.setDeleteCommentId(0))
                    await operation.send(.setShowDeleteAlert(false))
                }
            } else {
                return .send(.setShowDeleteAlert(false))
            }
        case .delegate: return .none
        }
    }
}

extension CommentListReducer {
    private func registerComment(with topicId: Int, comment: String) async -> Void {
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
    
    private func fetchComment(with topicId: Int) async -> [Model.Comment] {
        return await withCheckedContinuation({ continuation in
            API.FetchCommentList(topicID: topicId).request()
                .print("API.FetchCommentList")
                .sink { _ in
                } receiveValue: { comments in
                    continuation.resume(returning: comments)
                }.store(in: &bag)
        })
    }
    
    private func deleteComment(commentId: Int) async -> Void {
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
