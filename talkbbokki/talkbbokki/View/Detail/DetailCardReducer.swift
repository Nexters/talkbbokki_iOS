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

final class DetailCardReducer: ReducerProtocol {
    private var bag = Set<AnyCancellable>()
    private let topic: Model.Topic
    private let color: Int
    struct State: Equatable {
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
        case setShowComment(Bool)
        case fetchSaveTopic(id: Int)
        case didTapBookMark(Model.Topic, Int)
        case setToastMessage(String)
        case savePhoto(Model.Topic)
        case like(Model.Topic)
        case commentDelegate(CommentListReducer.Action)
    }
    
    init(topic: Model.Topic, color: Int) {
        self.topic = topic
        self.color = color
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { [weak self] state, action in
            guard let self = self else { return .none }
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
                return EffectTask.run { [weak self] send in
                    guard let self = self else { return }
                    await send.send(.setOrder(self.fetchOrder()))
                }
            case .fetchCommentCount(let topic):
                return EffectTask.run { [weak self] opertion in
                    guard let self = self else { return }
                    await opertion.send(.setCommentCount(self.fetchCommentCount(with: topic)))
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
                let renderImage = SavePhotoView(colorHex: self.color,
                                                contentMessage: topic.name,
                                                starter: (state.order?.rule).orEmpty).snapshot()
                UIImageWriteToSavedPhotosAlbum(renderImage,nil,nil,nil)
                state.isSuccessSavePhoto.toggle()
                return .none
            case .setIsSuccessSavePhoto:
                state.isSuccessSavePhoto.toggle()
                return .none
            case .like(let topic):
                self.requestLike(with: topic)
                return .none
            case .setShowComment(let isShow):
                state.showComment = isShow
                state.commentState = .init(topicID: self.topic.topicID,
                                           commentCount: state.commentCount)
                return .none
            case let .commentDelegate(.delegate(.changedComment(commentCount))):
                state.commentCount = commentCount
                return .none
//            case .commentDelegate(.delegate(.deleteComment)):
//                state.commentCount -= 1
//                return .none
            case .commentDelegate:
                return .none
            }
        }
        .ifLet(\.commentState, action: /Action.commentDelegate) {
            CommentListReducer()
        }
    }
    
    private func fetchOrder() async -> Model.Order {
        return await withCheckedContinuation({ contiuation in
            API.RecommendOrder().request()
                .first()
                .print("API.RecommendOrder")
                .sink { _ in
                } receiveValue: { topics in
                    contiuation.resume(returning: topics)
                }.store(in: &bag)
        })
    }
    
    private func requestLike(with topic: Model.Topic) {
        API.Like(topicID: topic.topicID)
            .request()
            .print("API.LIKE")
            .sink { _ in
            } receiveValue: { _ in
            }.store(in: &bag)
    }
    
    private func fetchCommentCount(with topic: Model.Topic) async -> Int {
        return await withCheckedContinuation({ continuation in
            API.CommentCount(topicID: topic.topicID)
                .request()
                .print("API.CommentCount")
                .sink { _ in
                } receiveValue: { commentCount in
                    continuation.resume(returning: commentCount)
                }.store(in: &bag)
        })
    }
}
