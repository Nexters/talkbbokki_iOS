//
//  NicknameSettingViewModel.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/04/27.
//

import Foundation
import Combine
import ComposableArchitecture

final class NickNameSettingReducer: ReducerProtocol {
    enum NickNameError {
        case validString
        case overCount
        case exists
        case minimumCount
        
        var errorMessage: String {
            switch self {
            case .validString: return "영어, 한글, 숫자로만 구성해 주세요."
            case .overCount: return "최대 입력 글자수를 초과하였습니다."
            case .exists: return "이미 사용중인 닉네임입니다."
            case .minimumCount: return "2자 이상의 닉네임을 입력해 주세요."
            }
        }
    }

    private var bag = Set<AnyCancellable>()
    struct State: Equatable {
        var nickName: String = ""
        var error: NickNameError? = nil
        var didTapConfirm: ButtonType = .none
    }
    
    enum Action {
        case updateTextField(String)
        case setError(NickNameError)
        case didTapConfirm
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .updateTextField(let text):
            if let error = text.isFilteringNickname() {
                return EffectTask.run { operation in
                    await operation.send(.setError(error))
                }
            }
            state.error = nil
            state.nickName = text
            return .none
        case .didTapConfirm:
            if let error = state.nickName.isValidCount() {
                return EffectTask.run { operation in
                    await operation.send(.setError(error))
                }
            }
            
            let nickName = state.nickName
            return EffectTask.run { [weak self] operation in
                guard let self = self else { return }
                await self.requestValidNickName(with: nickName) // return action
            }
        case .setError(let error):
            state.error = error
            return .none
        }
    }
}

extension NickNameSettingReducer {
    private func requestValidNickName(with nickName: String) async -> Result<Void, Error> {
        return await withCheckedContinuation({ contiuation in
            API.ValidNickname(nickName: nickName).request().sink { error in
                contiuation.resume(returning: .failure(error as! Error))
            } receiveValue: { _ in
                contiuation.resume(returning: .success(()))
            }.store(in: &bag)
        })
    }
}

private extension String {
    func isFilteringNickname() -> NickNameSettingReducer.NickNameError? {
        let filterString = "!@#$%^&*()_+=-,./<>?`~"
        if contains(filterString) {
            return .validString
        }

        if self.count >= 10 {
            return .overCount
        }

        return nil
    }
    
    func isValidCount() -> NickNameSettingReducer.NickNameError? {
        if self.count < 2 && self.count >= 1 {
            return .minimumCount
        }

        return nil
    }
}
