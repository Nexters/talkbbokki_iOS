//
//  Model.Order.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/14.
//

import Foundation

extension Model {
    struct Order: Codable, Equatable {
        let id: Int
        let rule: String
    }
}
