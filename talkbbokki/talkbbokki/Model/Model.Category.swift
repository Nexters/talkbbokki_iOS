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
        let bgColor: String
        let activeYn: Bool
        var imageName: String?
        
        var firstLineTitle: String {
            text.components(separatedBy: "\n").first.orEmpty
        }
        
        var secondLineTitle: String {
            text.components(separatedBy: "\n")[safe: 1].orEmpty
        }
        
        enum CodingKeys: String, CodingKey {
            case code, text, bgColor, activeYn
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            code = try container.decode(String.self, forKey: .code)
            text = try container.decode(String.self, forKey: .text)
            bgColor = try container.decode(String.self, forKey: .bgColor)
            activeYn = try container.decode(Bool.self, forKey: .activeYn)
        }
        
        init(code: String, text: String) {
            self.code = code
            self.text = text
            self.bgColor = ""
            self.activeYn = false
        }
        
        static var empty: Self {
            Category(code: "", text: "")
        }
    }
}
