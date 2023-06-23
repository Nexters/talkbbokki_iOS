//
//  DetailRepository.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/06/24.
//

import Foundation
import Combine

protocol DetailCardRepositoryType {
    func fetchOrder() async -> Model.Order
    func fetchCommentCount(with topic: Model.Topic) async -> Int
    func requestLike(with topic: Model.Topic)
}

final class DetailCardRepository: DetailCardRepositoryType {
    private var bag = Set<AnyCancellable>()
    
    func fetchOrder() async -> Model.Order {
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
    
    func requestLike(with topic: Model.Topic) {
        API.Like(topicID: topic.topicID)
            .request()
            .print("API.LIKE")
            .sink { _ in
            } receiveValue: { _ in
            }.store(in: &bag)
    }
    
    func fetchCommentCount(with topic: Model.Topic) async -> Int {
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
