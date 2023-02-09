//
//  Model.Category.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation

extension Model {
    struct Category: Codable, Equatable, Identifiable {
        var id: String { self.code }
        let code: String
        let text: String
    }
}
