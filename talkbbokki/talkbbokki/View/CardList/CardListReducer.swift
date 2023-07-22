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
    let color: Int
    struct State: Equatable {
        var didShowTopicIds: [Int] = []
        var topics: [Model.Topic] = []
        var errorMessage: String = ""
        var offsetX: Double = 0
        var currentIndex: Int = 0
        var viewCount: Int = 1
        var isShowDetailCard = false
        var detailCardState: DetailCardReducer.State?
    }
    
    enum Action {
        case fetchDidShowTopics
        case fetchCard(category: String)
        case fetchResult(Result<[Model.Topic], Error>)
        case fetchViewCount
        case changedCurrentIndex(Int)
        case setShowDetailCardReducer(Bool)
        case setTopics([Model.Topic])
        case setError(Error)
        case setPositionTopic(cardNumber: Int, currentIndex: Int)
        case setOffset(Double)
        case detailCardDelegate(DetailCardReducer.Action)
    }
    
    init(color: Int) {
        self.color = color
    }
    
    var body: some ReducerProtocolOf<CardListReducer> {
        Reduce { [weak self] state, action in
            guard let self = self else { return .none }
            switch action {
            case .fetchDidShowTopics:
                state.didShowTopicIds = UserDefaultValue.didShowTopic
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
                state.viewCount = UserDefaultValue.viewCount
                return .none
            case .setTopics(let topics):
                state.topics = topics.enumerated().map { index, topic in
                    var tempTopic = topic
                    tempTopic.cardNumber = index
                    return tempTopic
                }
                
                state.offsetX = (UIScreen.main.bounds.width - self.width)/2
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
            case .setShowDetailCardReducer(let isShow):
                state.isShowDetailCard = isShow
                state.detailCardState = DetailCardReducer.State(cards: state.topics,
                                                                color: self.color,
                                                                selectedIndex: state.currentIndex,
                                                                card: state.topics[state.currentIndex]
                )
                return .none
            case let .detailCardDelegate(.delegate(.changedCardIndex(index))):
                state.currentIndex = index
                return .none
            case .detailCardDelegate: return .none
            }
        }
        .ifLet(\.detailCardState, action: /Action.detailCardDelegate) {
            DetailCardReducer()
        }
    }
    
    private func fetchTopics(with category: String) async -> [Model.Topic] {
        return await withCheckedContinuation({ contiuation in
            if let topics = UserDefaultValue.topicDict?[category] {
                contiuation.resume(returning: topics.shuffled())
                return
            }
            
            API.Topics(category: category).request()
                .first()
                .print("API.Topics()")
                .sink { _ in
                } receiveValue: { topics in
                    UserDefaultValue.topicDict?[category] = topics
                    contiuation.resume(returning: topics)
                }.store(in: &bag)
        })
    }
}
