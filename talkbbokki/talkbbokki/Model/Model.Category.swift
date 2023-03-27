//
//  Model.Category.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation

extension Model.Category {
    enum Level: String {
        case level1
        case level2
        case level3
        case event
    }
}

extension Model {
    struct Category: Codable, Equatable, Identifiable {
        var id: String { self.code }
        let code: String
        let text: String
        let bgColor: String
        let activeYn: Bool
        var imageUrl: String?
        var filePath: String?

        var firstLineTitle: String {
            text.components(separatedBy: "\n").first.orEmpty
        }
        
        var secondLineTitle: String {
            text.components(separatedBy: "\n")[safe: 1].orEmpty
        }
        
        enum CodingKeys: String, CodingKey {
            case code, text, bgColor, activeYn, imageUrl
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            code = try container.decode(String.self, forKey: .code)
            text = try container.decode(String.self, forKey: .text)
            bgColor = try container.decode(String.self, forKey: .bgColor)
            activeYn = try container.decode(Bool.self, forKey: .activeYn)
            imageUrl = try container.decode(String.self, forKey: .imageUrl)
        }
        
        init(code: String, text: String, bgColor: String = "", activeYn: Bool = false, imageUrl: String = "", filePath: String? = nil) {
            self.code = code
            self.text = text
            self.bgColor = bgColor
            self.activeYn = activeYn
            self.imageUrl = imageUrl
            self.filePath = filePath
        }
        
        var imagePath: String {
            "\(FileUtil.shared.rootDirectory.orEmpty)/\(filePath.orEmpty)"
        }
        
        static var empty: Self {
            Category(code: "", text: "")
        }
    }
}
