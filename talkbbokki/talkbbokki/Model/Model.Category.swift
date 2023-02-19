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
        var imageName: String?
        
        var firstLineTitle: String {
            text.components(separatedBy: "\n").first.orEmpty
        }
        
        var secondLineTitle: String {
            text.components(separatedBy: "\n")[safe: 1].orEmpty
        }
        
        enum CodingKeys: String, CodingKey {
            case code, text, bgColor
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            code = try container.decode(String.self, forKey: .code)
            text = try container.decode(String.self, forKey: .text)
            bgColor = try container.decode(String.self, forKey: .bgColor)
        }
        
        init(code: String, text: String) {
            self.code = code
            self.text = text
            self.bgColor = ""
        }
        
        static var empty: Self {
            Category(code: "", text: "")
        }
    }
}
