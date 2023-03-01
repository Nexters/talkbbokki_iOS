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
        var toastMessage: String = ""
    }
    
    enum Action {
        case resetViewCount
        case addViewCount(Model.Topic)
        case saveTopic(Model.Topic)
        case fetchOrder
        case orderResult(Result<Model.Order, Error>)
        case setOrder(Model.Order)
        case setError(Error)
        case setIsSuccessSavePhoto
        case setSaveTopic(Bool)
        case fetchSaveTopic(id: Int)
        case didTapBookMark(Model.Topic, Int)
        case setToastMessage(String)
        case savePhoto(Model.Topic)
        case like(Model.Topic)
    }
    
    init(topic: Model.Topic, color: Int) {
        self.topic = topic
        self.color = color
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .resetViewCount:
            UserDefaultValue.Onboard.viewCount = 0
            return .none
        case .addViewCount(let topic):
            let topics = UserDefaultValue.Onboard.didShowTopic
            var viewCount = UserDefaultValue.Onboard.viewCount
            if topics.contains(where: { $0 == topic.topicID }) == false {
                viewCount += 1
            }
            UserDefaultValue.Onboard.viewCount = viewCount
            return .none
        case .saveTopic(let topic):
            var topics = UserDefaultValue.Onboard.didShowTopic
            if topics.contains(where: { $0 == topic.topicID }) == false {
                topics.append(topic.topicID)
            }
            UserDefaultValue.Onboard.didShowTopic = topics
            return .none
        case .fetchOrder:
            return EffectTask.run { send in
                await send.send(.setOrder(self.fetchOrder()))
            }
        case .orderResult(let result):
            switch result {
            case .success(let order):
                return .send(.setOrder(order))
            case .failure(let error):
                return .send(.setError(error))
            }
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
            return EffectTask.run { [state] send in
                if state.isSaveTopic {
                    let isDelete = await CoreDataManager.shared.topic.deleteTopic(id: topic.topicID)
                    if isDelete {
                        await send.send(.setSaveTopic(false))
                    }
                } else {
                    let isSave = await CoreDataManager.shared.topic.save(topic: topic, bgColor: color)
                    if isSave {
                        await send.send(.setToastMessage("즐겨찾기 등록 완료!"))
                        await send.send(.setSaveTopic(true))
                    }
                }
            }
        case .savePhoto(let topic):
            let renderImage = SavePhotoView(colorHex: color,
                                            contentMessage: topic.name,
                                            starter: (state.order?.rule).orEmpty).snapshot()
            UIImageWriteToSavedPhotosAlbum(renderImage,nil,nil,nil)
            state.isSuccessSavePhoto.toggle()
            return .none
        case .setIsSuccessSavePhoto:
            state.isSuccessSavePhoto.toggle()
            return .none
        case .like(let topic):
            requestLike(with: topic)
            return .none
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
    
    @objc
    private func screenshotTaken() {
        requestLike(with: self.topic)
    }
}
