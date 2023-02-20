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
    private var onSuccessSavePhoto:(()->()) = {}
    struct State: Equatable {
        var order: Model.Order?
        var errorMessage: String = ""
        var isShowBookMarkAlert = false
        var isSuccessSavePhoto = false
    }
    
    enum Action {
        case fetchOrder
        case orderResult(Result<Model.Order, Error>)
        case setOrder(Model.Order)
        case setError(Error)
        case setIsSuccessSavePhoto
        case showBookMarkAlert
        case savePhoto(Model.Topic)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
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
        case .showBookMarkAlert:
            state.isShowBookMarkAlert.toggle()
            return .none
        case .savePhoto(let topic):
            let renderImage = DetailBackCardView(card: topic,
                                                 order: state.order,
                                                 touchedDownload: .constant(false),
                                                 touchedRefreshOrder: .constant(false),
                                                 touchedBookMark: .constant(false),
                                                 degree: .constant(0.0)).snapshot()
            UIImageWriteToSavedPhotosAlbum(renderImage,nil,nil,nil)
            state.isSuccessSavePhoto.toggle()
            return .none
        case .setIsSuccessSavePhoto:
            state.isSuccessSavePhoto.toggle()
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
}
