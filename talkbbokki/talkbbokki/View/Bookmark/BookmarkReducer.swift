//
//  BookmarkReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/02/28.
//

import Combine
import ComposableArchitecture

final class BookmarkReducer: ReducerProtocol {
    struct State: Equatable {
        var bookmarks: [Topic] = []
    }
    
    enum Action {
        case fetchBookmarkList
        case removeBookmark(Int)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .removeBookmark(let topicID):
            return EffectTask.run { send in
                let isDelete = await CoreDataManager.shared.topic.deleteTopic(id: topicID)
                if isDelete {
                    await send.send(.fetchBookmarkList)
                }
            }
        case .fetchBookmarkList:
            if let topics = CoreDataManager.shared.topic.fetchTopics() {
                state.bookmarks = topics
            }
            return .none
        }
    }
}

