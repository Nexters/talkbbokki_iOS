//
//  CardListViewModel.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation
import Combine

class CardListViewModel {
    private var bag = Set<AnyCancellable>()
    init() {
    }
    
    func start() {
        API.Category()
            .request()
            .print("[API.Category]")
            .eraseToAnyPublisher()
            .sink { completion in
                
            } receiveValue: { category in
                print(category)
            }.store(in: &bag)
    }
}
