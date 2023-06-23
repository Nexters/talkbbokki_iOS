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
        case invalidString
        case overCount
        case exists
        case minimumCount
        
        var errorMessage: String {
            switch self {
            case .invalidString: return "영어, 한글, 숫자로만 구성해 주세요."
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
        var isSuccessNickName: Bool = false
        var isHideCloseButton: Bool = false
    }
    
    enum Action {
        case updateTextField(String)
        case setError(NickNameError)
        case checkValidNickName(TaskResult<Void>)
        case registerUser
        case didUpdateNickResult(TaskResult<Void>)
        case didTapConfirm
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .updateTextField(let text):
            state.nickName = text
            if let error = text.isFilteringNickname() {
                return EffectTask.run { operation in
                    await operation.send(.setError(error))
                }
            }
            state.error = nil
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
                await operation.send(.checkValidNickName(self.requestValidNickName(with: nickName)))
            }
            
        case .checkValidNickName(let result):
            return EffectTask.run { operation in
                switch result {
                case .success:
                    await operation.send(.registerUser)
                case .failure(let error):
                    await operation.send(.didUpdateNickResult(.failure(error)))
                }
            }
            
        case .registerUser:
            return EffectTask.run { [weak self, nickName = state.nickName] operation in
                guard let self = self else { return }
                await operation.send(.didUpdateNickResult(self.registerUser(nickName: nickName)))
            }
            
        case .didUpdateNickResult(.success):
            UserDefaultValue.nickName = state.nickName
            state.isSuccessNickName.toggle()
            return .none
            
        case .didUpdateNickResult(.failure):
            state.error = .exists
            return .none
        case .setError(let error):
            state.error = error
            return .none
        }
    }
}

extension NickNameSettingReducer {
    private func requestValidNickName(with nickName: String) async -> TaskResult<Void> {
        return await withCheckedContinuation({ contiuation in
            API.ValidNickname(nickName: nickName).request()
                .print("API.ValidNickname")
                .sink { completion in
                    guard let error = completion.error else { return }
                    contiuation.resume(returning: .failure(error))
                } receiveValue: { _ in
                    contiuation.resume(returning: .success(()))
                }.store(in: &bag)
        })
    }
    
    private func registerUser(nickName: String) async -> TaskResult<Void> {
        return await withCheckedContinuation({ contiuation in
            API.RegisterUser(uuid: Utils.getDeviceUUID(),
                             pushToken: UserDefaultValue.pushToken,
                             nickName: nickName)
                .request()
                .print("API.RegisterUser")
                .sink { completion in
                    guard let error = completion.error else { return }
                    contiuation.resume(returning: .failure(error))
                } receiveValue: { _ in
                    contiuation.resume(returning: .success(()))
                }.store(in: &bag)
        })
    }
}

private extension String {
    func isFilteringNickname() -> NickNameSettingReducer.NickNameError? {
        if validateString(".*[^가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9].*") {
            return .invalidString
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
