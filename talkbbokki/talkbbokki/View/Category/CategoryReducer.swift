//
//  CategoryReducer.swift
//  talkbbokki
//
//  Created by USER on 2023/02/10.
//
import Foundation
import Alamofire
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
            API.Category().request().first()
                .flatMap { [weak self] categories -> AnyPublisher<[Model.Category], Never> in
                    guard let self = self else { return Empty().eraseToAnyPublisher() }
                    if let savedCategories = CoreDataManager.shared.category.fetch(),
                       savedCategories.compare(with: categories) {
                        return Just(savedCategories.convert).eraseToAnyPublisher()
                    } else {
                        return self.downloadImages(with: categories).eraseToAnyPublisher()
                    }
                }
                .print("API.Category()")
                .sink { _ in
                } receiveValue: { categories in
                    contiuation.resume(returning: categories)
                }.store(in: &bag)
        })
    }
    
    private func downloadImages(with categroies: [Model.Category]) -> Future<[Model.Category], Never> {
        Future { [weak self] promise in
            guard let self = self else { return }
            var index = 0
            var downloadCategories = [Model.Category]()
            let downloadSubject = PassthroughSubject<Model.Category?, Never>()
            downloadSubject
                .compactMap { $0 }
                .flatMap { [weak self] category -> AnyPublisher<Model.Category, Never> in
                    guard let self = self else { return Empty().eraseToAnyPublisher() }
                    return self.download(category, priority: index).eraseToAnyPublisher()
                }.sink { category in
                    downloadCategories.append(category)
                    if downloadCategories.count >= categroies.count {
                        promise(.success(downloadCategories))
                    } else {
                        index += 1
                        downloadSubject.send(categroies[safe: index])
                    }
                }.store(in: &self.bag)
            
            downloadSubject.send(categroies[safe: index])
        }
    }
    
    private func download(_ category :Model.Category, priority: Int) -> Future<Model.Category, Never>{
        Future { promise in
            var tempCategory = category
            let urlStr = FileUtil.shared.makePath(name: category.code)
            let filePath = FileUtil.shared.makeFilePath(urlStr.orEmpty)
            FileUtil.shared.createDirectory(path: FileUtil.shared.rootDirectory.orEmpty)
            tempCategory.filePath = category.code+".png"
            _ = CoreDataManager.shared.category.delete(code: category.code)
            
            guard let url = URL(string: category.imageUrl.orEmpty) else {
                promise(.success(tempCategory))
                return
            }
            let request = URLRequest(url: url)
            let destination: DownloadRequest.Destination = { _, _ in
                return (filePath, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            let download = AF.download(request, to: destination)
            download
                .validate()
                .response { response in
                    print("[CategoryReducer] success download image")
                    _ = CoreDataManager.shared.category.save(category: tempCategory, priority: priority)
                    promise(.success(tempCategory))
                }
        }
    }
}

private extension Array where Element == Category {
    func compare(with modelCategories: [Model.Category]) -> Bool {
        guard self.count > 0 else { return false }
        let result =  self.map { category in
            if let cache = modelCategories.first(where: { $0.code == category.code }) {
                return (category.code == cache.code) &&
                (category.activeYn == cache.activeYn) &&
                (category.text == cache.text) &&
                (category.bgColor == cache.bgColor) &&
                (category.imageUrl == cache.imageUrl)
            }
            return false
        }
        
        return !result.contains(false)
    }
    
    var convert: [Model.Category] {
        return map { category in
            Model.Category(code: category.code.orEmpty,
                           text: category.text.orEmpty,
                           bgColor: category.bgColor.orEmpty,
                           activeYn: category.activeYn,
                           imageUrl: category.imageUrl.orEmpty,
                           filePath: category.filePath.orEmpty)
        }
    }
}
