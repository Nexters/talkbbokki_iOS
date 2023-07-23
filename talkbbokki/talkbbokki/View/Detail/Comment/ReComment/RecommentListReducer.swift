//
//  RecommentListReducer.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/07/22.
//

import Foundation
import ComposableArchitecture

struct RecommentListReducer: ReducerProtocol {
    private let repository: CommentListRepositoryType
    struct State: Equatable {
        let parentComment: Model.Comment
        var commentsCount: Int
        var comments: [Model.Comment] = []
        var nextPage: Int?
        var prevPage: Int?
        var inputString: String = ""
    }

    enum Action {
        case fetchReCommentList(topicId: Int, parentId: Int)
        case setReCommentList(Model.CommentList)
        case setInputString(String)
        case registerRecomment(
            message: String,
            topicId: Int,
            parentCommentId: Int
        )
        case updateCommentCount(parentCommentId: Int, operator: OperatorCount)
        case delegate(DelegateAction)
    }

    enum OperatorCount {
        case plus(Int)
        case minus(Int)
    }

    enum DelegateAction: Equatable {
        case changedReCommentCount(parentCommentId: Int, count: Int)
    }

    init(repository: CommentListRepositoryType = CommentListRepository()) {
        self.repository = repository
    }

    var body: some ReducerProtocolOf<RecommentListReducer> {
        Reduce { state, action in
            switch action {
            case let .fetchReCommentList(topicId, parentId):
                return .run { operation in
                    let comments = await repository.fetchChildComment(with: topicId, parentCommentId: parentId, next: nil)
                    await operation.send(.setReCommentList(comments))
                }
            case let .setReCommentList(list):
                state.comments = list.comments
                state.nextPage = list.next
                state.prevPage = list.previous
                return .none
            case let .setInputString(string):
                state.inputString = string
                return .none
            case let .registerRecomment(message, topicId, parentCommentId):
                return .run { operation in
                    await repository.registerComment(with: topicId, parentCommentId: parentCommentId, comment: message)
                    await operation.send(.fetchReCommentList(topicId: topicId, parentId: parentCommentId))
                    await operation.send(.setInputString(""))
                    await operation.send(.updateCommentCount(parentCommentId: parentCommentId, operator: .plus(1)))
                }
            case let .updateCommentCount(parentCommentId, operatorion):
                switch operatorion {
                case let .minus(val):
                    state.commentsCount -= val
                case let .plus(val):
                    state.commentsCount += val
                }

                return .run { [state] operation in
                    await operation.send(.delegate(.changedReCommentCount(parentCommentId: parentCommentId,
                                                                          count: state.commentsCount)))
                }
            case .delegate: return .none
            }
        }
    }
}
