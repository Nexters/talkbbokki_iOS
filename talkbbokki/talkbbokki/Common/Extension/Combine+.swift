//
//  Combine+.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/04/30.
//

import Combine

extension Subscribers.Completion {
    var error: Error? {
        switch self {
        case .finished: return nil
        case .failure(let error): return error
        }
    }
}
