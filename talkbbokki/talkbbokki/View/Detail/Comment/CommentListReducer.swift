//
//  CommentReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import ComposableArchitecture

struct CommentListReducer: ReducerProtocol {
    private let repository: CommentListRepositoryType
    struct State: Equatable {
        let topicID: Int
        var didLoad = false
        var commentCount: Int = 0
        var inputComment: String = ""
        var deleteCommentId: Int = 0
        var nextPage: Int?
        var prevPage: Int?
        var comments: [Model.Comment] = []
        var showDeleteAlert = false
        var tapDeleteAlert: ButtonType = .none
    }
    
    enum Action {
        case setInputComment(String)
        case setDeleteCommentId(Int)
        case registerComment(String)
        case fetchComments
        case setCommentList(Model.CommentList)
        case setShowDeleteAlert(Bool)
        case setTapDeleteAlert(ButtonType)
        case removeComment(Int)
        case updateCommentCount(OperatorCount)
        case delegate(DelegateAction)
    }
    
    enum DelegateAction: Equatable {
        case changedComment(Int)
    }
    
    enum OperatorCount {
        case plus(Int)
        case minus(Int)
    }
    
    init(repository: CommentListRepositoryType = CommentListRepository()) {
        self.repository = repository
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
            return EffectTask.run { [state = state] operation in
                await repository.registerComment(with: state.topicID, comment: comment)
                await operation.send(.fetchComments)
                await operation.send(.setInputComment(""))
                await operation.send(.updateCommentCount(.plus(1)))
            }
        case .fetchComments:
            return EffectTask.run { [topicID = state.topicID] operation in
//                guard let self = self else { return }
                await operation.send(.setCommentList(repository.fetchComment(with: topicID)))
            }
        case .setCommentList(let commentResponse):
            state.comments = commentResponse.comments
            state.prevPage = commentResponse.previous
            state.nextPage = commentResponse.next
            state.didLoad = true
            return .send(.delegate(.changedComment(state.commentCount)))
        case .removeComment(let id):
            state.comments.removeAll { $0._id == id }
            return .run { [count = state.commentCount] operation in
                await operation.send(.delegate(.changedComment(count)))
                await operation.send(.updateCommentCount(.minus(1)))
            }
        case .updateCommentCount(let operation):
            switch operation {
            case .plus(let val):
                state.commentCount += val
            case .minus(let val):
                state.commentCount -= val
            }
            return .none
        case .setTapDeleteAlert(let type):
            state.tapDeleteAlert = type
            if case .ok = type {
                return .run { [state = state] operation in
                    await repository.deleteComment(commentId: state.deleteCommentId)
                    await operation.send(.removeComment(state.deleteCommentId))
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
