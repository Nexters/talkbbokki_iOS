//
//  CategoryReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/02/10.
//

import ComposableArchitecture
import Combine

class CategoryReducer: ReducerProtocol {
    private let categoriesImages: [String] = [
        "hand",
        "Bowl_Graphic",
        "Beer_Graphic",
        "ComingSoon_Graphic",
    ]
    private var bag = Set<AnyCancellable>()
    struct State: Equatable {
        var categories: [Model.Category] = []
        var errorMessage: String = ""
        var isShowAlert: Bool = false
    }
    
    enum Action {
        case fetchCategories
        case fetchResult(Result<[Model.Category], Error>)
        case setCategories([Model.Category])
        case setError(Error)
        case showAlert
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
        case .showAlert:
            state.isShowAlert.toggle()
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
                    let imageCategories = categories.enumerated().map { index, category in
                        var imageCategory = category
                        imageCategory.imageName = self.categoriesImages[safe: index] ?? ""
                        return imageCategory
                    }
                    contiuation.resume(returning: imageCategories)
                }.store(in: &bag)
        })
    }
}
