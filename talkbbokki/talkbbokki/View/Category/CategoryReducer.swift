//
//  CategoryReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/02/10.
//

import ComposableArchitecture
import Combine

class CategoryReducer: ReducerProtocol {
    private var bag = Set<AnyCancellable>()
    struct State: Equatable {
        var categories: [Model.Category] = []
        var errorMessage: String = ""
    }
    
    enum Action {
        case fetchCategories
        case fetchResult(Result<[Model.Category], Error>)
        case setCategories([Model.Category])
        case setError(Error)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchCategories:
            return EffectTask.run { send in
                await send.send(.setCategories(self.fetchCategory()))
            }
        case .fetchResult(let result):
            switch result {
            case .success(let categories):
                return .send(.setCategories(categories))
            case .failure(let error):
                return .send(.setError(error))
            }
        case .setCategories(let categories):
            state.categories = categories
            return .none
        case .setError(let error):
            state.errorMessage = error.localizedDescription
            return .none
        }
    }
    
    private func fetchCategory() async -> [Model.Category] {
        return await withCheckedContinuation({ contiuation in
            API.Category().request()
                .first()
                .print("API.Category()")
                .sink { _ in
                } receiveValue: { categories in
                    let models = [
                        Model.Category(code: "1", text: "aa"),
                        Model.Category(code: "2", text: "bb"),
                        Model.Category(code: "2", text: "cc"),
                        Model.Category(code: "2", text: "ee"),
                    ]
                    contiuation.resume(returning: models)
                }.store(in: &bag)
        })
    }
}
