//
//  DetailCardReducer.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/14.
//

import Foundation
import ComposableArchitecture
import Combine
import UIKit
import Photos

private enum Constant {
    static let viewCount = 5.0
}

struct DetailCardReducer: ReducerProtocol {
    private var bag = Set<AnyCancellable>()
    private let repository: DetailCardRepositoryType = DetailCardRepository()
    struct State: Equatable {
        let cards: [Model.Topic]
        let color: Int
        var selectedIndex: Int
        var card: Model.Topic
        var order: Model.Order?
        var errorMessage: String = ""
        var isShowBookMarkAlert = false
        var isSuccessSavePhoto = false
        var isSaveTopic = false
        var showComment = false
        var toastMessage: String = ""
        var commentCount = 0
        var commentState: CommentListReducer.State?
    }
    
    enum Action {
        case resetViewCount
        case addViewCount(Model.Topic)
        case saveTopic(Model.Topic)
        case fetchOrder
        case fetchCommentCount(Model.Topic)
        case orderResult(Result<Model.Order, Error>)
        case setOrder(Model.Order)
        case setCommentCount(Int)
        case setError(Error)
        case setIsSuccessSavePhoto
        case setSaveTopic(Bool)
        case setSelectedIndex(Int)
        case setShowComment(Bool)
        case fetchSaveTopic(id: Int)
        case didTapBookMark(Model.Topic, Int)
        case setToastMessage(String)
        case savePhoto(Model.Topic)
        case like(Model.Topic)
        case commentDelegate(CommentListReducer.Action)
        case delegate(DelegateAction)
    }
    
    enum DelegateAction: Equatable {
        case changedCardIndex(Int)
    }

    var body: some ReducerProtocolOf<DetailCardReducer> {
        Reduce { state, action in
            switch action {
            case .resetViewCount:
                UserDefaultValue.viewCount = 1
                return .none
            case .addViewCount(let topic):
                let topics = UserDefaultValue.didShowTopic
                var viewCount = UserDefaultValue.viewCount
                if topics.contains(where: { $0 == topic.topicID }) == false {
                    viewCount += 1
                }
                UserDefaultValue.viewCount = viewCount
                return .none
            case .saveTopic(let topic):
                var topics = UserDefaultValue.didShowTopic
                if topics.contains(where: { $0 == topic.topicID }) == false {
                    topics.append(topic.topicID)
                }
                UserDefaultValue.didShowTopic = topics
                return .none
            case .fetchOrder:
                return EffectTask.run { send in
                    await send.send(.setOrder(repository.fetchOrder()))
                }
            case .fetchCommentCount(let topic):
                return EffectTask.run { opertion in
                    await opertion.send(.setCommentCount(repository.fetchCommentCount(with: topic)))
                }
            case .orderResult(let result):
                switch result {
                case .success(let order):
                    return .send(.setOrder(order))
                case .failure(let error):
                    return .send(.setError(error))
                }
            case .setCommentCount(let commentCount):
                state.commentCount = commentCount
                return .none
            case .setOrder(let order):
                state.order = order
                return .none
            case .setSelectedIndex(let index):
                guard state.cards.count > index,
                      index > 0 else { return .none }
                state.selectedIndex = index
                state.card = state.cards[index]
                return EffectTask.run { [state] operation in
                    await operation.send(.delegate(.changedCardIndex(index)))
                    await operation.send(.fetchSaveTopic(id: state.card.topicID))
                    await operation.send(.addViewCount(state.card))
                    await operation.send(.saveTopic(state.card))
                    await operation.send(.fetchOrder)
                    await operation.send(.fetchCommentCount(state.card))

                    let like = Task.delayed(byTimeInterval: Constant.viewCount) {
                        await operation.send(.like(state.card))
                    }
                    
                    Task {
                        like.cancel
                    }

                }
            case .setError(let error):
                state.errorMessage = error.localizedDescription
                return .none
            case .setSaveTopic(let isSave):
                state.isSaveTopic = isSave
                return .none
            case .fetchSaveTopic(let id):
                let topic = CoreDataManager.shared.topic.fetchTopic(with: id)
                state.isSaveTopic = topic.isNonEmpty
                return .none
            case .setToastMessage(let message):
                state.toastMessage = message
                return .none
            case .didTapBookMark(let topic, let color):
                if state.isSaveTopic {
                    _ = CoreDataManager.shared.topic.deleteTopic(id: topic.topicID)
                    return EffectTask.send(.setSaveTopic(false))
                } else {
                    return EffectTask.run { send in
                        let isSave = await CoreDataManager.shared.topic.save(topic: topic, bgColor: color)
                        if isSave {
                            await send.send(.setToastMessage("즐겨찾기 등록 완료!"))
                            await send.send(.setSaveTopic(true))
                        }
                    }
                }
            case .savePhoto(let topic):
                let renderImage = SavePhotoView(colorHex: state.color,
                                                contentMessage: topic.name,
                                                starter: (state.order?.rule).orEmpty).snapshot()
                UIImageWriteToSavedPhotosAlbum(renderImage,nil,nil,nil)
                state.isSuccessSavePhoto.toggle()
                return .none
            case .setIsSuccessSavePhoto:
                state.isSuccessSavePhoto.toggle()
                return .none
            case .like(let topic):
                repository.requestLike(with: topic)
                return .none
            case .setShowComment(let isShow):
                state.showComment = isShow
                state.commentState = .init(topicID: state.card.topicID,
                                           commentCount: state.commentCount)
                print("set commentState CommentListReducer")
                return .none
            case let .commentDelegate(.delegate(.changedComment(commentCount))):
                state.commentCount = commentCount
                return .none
            case .commentDelegate: return .none
            case .delegate: return .none
            }
        }
        .ifLet(\.commentState, action: /Action.commentDelegate) {
            CommentListReducer()
        }
    }
}
