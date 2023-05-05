//
//  CommentReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import Combine
import ComposableArchitecture

final class CommentReducer: ReducerProtocol {
    private var bag = Set<AnyCancellable>()
    
    struct State: Equatable {
        let topicID: Int
        var commentCount: Int = 0
        var inputComment: String = ""
    }
    
    enum Action {
        case setInputComment(String)
        case registerComment(String)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .setInputComment(let comment):
            state.inputComment = comment
            return .none
        case .registerComment(let comment):
            return EffectTask.run { [weak self, topicID = state.topicID] operation in
                await self?.registerComment(with: topicID, comment: comment)
            }
        }
    }
}

extension CommentReducer {
    private func registerComment(with topicId: Int, comment: String) async -> Void {
        return await withCheckedContinuation({ continuation in
            API.RegisterComment(topicID: topicId, comment: comment, userID: Utils.getDeviceUUID())
                .request()
                .print("API.RegisterComment")
                .sink { _ in
                } receiveValue: { commentCount in
                    continuation.resume(returning: ())
                }.store(in: &bag)
        })
    }
}
