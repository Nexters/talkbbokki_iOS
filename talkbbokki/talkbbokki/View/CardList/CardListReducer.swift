//
//  CardListReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import UIKit
import ComposableArchitecture
import Combine

private enum Design {
    enum Constraint {
        struct CardView {
            static let width: CGFloat = 223
        }
        
        struct CardListView {
            static let spacing: CGFloat = -50
        }
    }
}

final class CardListReducer: ReducerProtocol {
    private let width: Double = Design.Constraint.CardView.width
    private let spacing: CGFloat = Design.Constraint.CardListView.spacing
    private var bag = Set<AnyCancellable>()
    
    struct State: Equatable {
        var didShowTopicIds: [Int] = []
        var topics: [Model.Topic] = []
        var errorMessage: String = ""
        var offsetX: Double = 0
        var currentIndex: Int = -1
        var viewCount: Int = 0
    }
    
    enum Action {
        case fetchDidShowTopics
        case fetchCard(category: String)
        case fetchResult(Result<[Model.Topic], Error>)
        case fetchViewCount
        case changedCurrentIndex(Int)
        case setTopics([Model.Topic])
        case setError(Error)
        case setPositionTopic(cardNumber: Int, currentIndex: Int)
        case setOffset(Double)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchDidShowTopics:
            state.didShowTopicIds = UserDefaultValue.Onboard.didShowTopic
            return .none
        case .fetchCard(let category):
            return EffectTask.run { send in
                await send.send(.setTopics(self.fetchTopics(with: category)))
            }
        case .fetchResult(let result):
            switch result {
            case .success(let topics):
                return .send(.setTopics(topics))
            case .failure(let error):
                return .send(.setError(error))
            }
        case .fetchViewCount:
            state.viewCount = UserDefaultValue.Onboard.viewCount
            return .none
        case .setTopics(let topics):
            state.topics = topics.enumerated().map { index, topic in
                var tempTopic = topic
                tempTopic.cardNumber = index
                return tempTopic
            }
            
            state.offsetX = (UIScreen.main.bounds.width - width)/2
            return EffectTask.concatenate(
                state.topics.map { topic in
                    EffectTask.send(Action.setPositionTopic(cardNumber: topic.cardNumber, currentIndex: state.currentIndex))
                }
            )
        case .setError(let error):
            state.errorMessage = error.localizedDescription
            return .none
        case .changedCurrentIndex(let index):
            state.currentIndex = index
            HapticManager.instance.impact(style: .light)
            return EffectTask.concatenate(
                state.topics.map { topic in
                    EffectTask.send(Action.setPositionTopic(cardNumber: topic.cardNumber, currentIndex: index))
                }
            )
        case .setPositionTopic(let cardNumber, let currentIndex):
            var topics = state.topics
            let differ = cardNumber - currentIndex
            switch differ {
            case 0:
                topics[cardNumber].position = .selected
            case -1:
                topics[cardNumber].position = .prev
            case -2:
                topics[cardNumber].position = .beforePrev
            case 1:
                topics[cardNumber].position = .next
            case 2:
                topics[cardNumber].position = .afterNext
            case _ where differ > 0:
                topics[cardNumber].position = .right
            case _ where differ < 0:
                topics[cardNumber].position = .left
            default:
                topics[cardNumber].position = .none
            }
            
            state.topics = topics
            return .none
        case .setOffset(let offsetX):
            state.offsetX = offsetX
            return .none
        }
    }
    
    private func fetchTopics(with category: String) async -> [Model.Topic] {
        return await withCheckedContinuation({ contiuation in
            API.Topics(category: category).request()
                .first()
                .print("API.Topics()")
                .sink { _ in
                } receiveValue: { topics in
                    contiuation.resume(returning: topics)
                }.store(in: &bag)
        })
    }
}
