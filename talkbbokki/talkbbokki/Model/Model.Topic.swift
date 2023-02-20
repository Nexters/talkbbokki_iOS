//
//  Model.Card.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//

import Foundation
import SwiftUI
extension Model {
    struct Topic : Codable, Identifiable, Equatable {
        var id : Int { cardNumber }
        let topicID: Int
        let name : String
        let viewCount: Int
        let createAt: String
        let category: String
        let pcLink: String
        let tag: Tag

        enum CodingKeys: String, CodingKey {
            case topicID = "id"
            case name, viewCount, createAt, category,pcLink,tag
        }
        
        init(cardNumber: Int,
             topicID: Int,
             name : String,
             viewCount: Int,
             createAt: String,
             category: String,
             pcLink: String,
             tag: Tag
        ) {
            self.cardNumber = cardNumber
            self.topicID = topicID
            self.name = name
            self.viewCount = viewCount
            self.createAt = createAt
            self.category = category
            self.pcLink = pcLink
            self.tag = tag
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            topicID = try container.decode(Int.self, forKey: .topicID)
            name = try container.decode(String.self, forKey: .name)
            viewCount = try container.decode(Int.self, forKey: .viewCount)
            createAt = try container.decode(String.self, forKey: .createAt)
            category = try container.decode(String.self, forKey: .category)
            pcLink = try container.decode(String.self, forKey: .pcLink)
            tag = try container.decode(Tag.self, forKey: .tag)
        }

        var cardNumber = 0
        var degree: Double = 0.0
        var position: Position = .none

        enum Position {
            case beforePrev
            case prev
            case selected
            case next
            case afterNext
            case right
            case left
            case none
            
            var degree: Double {
                switch self {
                case .beforePrev, .left: return -30.0
                case .prev: return -15.0
                case .next: return 15.0
                case .afterNext, .right: return 30.0
                case .selected: return 0.0
                case .none: return 0.0
                }
            }
            
            var positionY: Double {
                switch self {
                case .beforePrev, .left: return 70.0
                case .prev: return 50.0
                case .next: return 50.0
                case .afterNext, .right: return 70.0
                case .selected: return 0.0
                case .none: return 0.0
                }
            }
            
            var size: CGSize {
                switch self {
                case .beforePrev, .left: return CGSize(width: 110, height: 156)
                case .prev: return CGSize(width: 134, height: 190)
                case .next: return CGSize(width: 134, height: 190)
                case .afterNext, .right: return CGSize(width: 110, height: 156)
                case .selected: return CGSize(width: 223, height: 346)
                case .none: return CGSize(width: 0, height: 0)
                }
            }
            
            var background: Image {
                switch self {
                case .beforePrev,.left: return Image("selectedCardSmall")
                case .prev: return Image("selectedCardRegular")
                case .next: return Image("selectedCardRegular")
                case .afterNext,.right: return Image("selectedCardSmall")
                case .selected: return Image("selectedCard")
                case .none: return Image("")
                }
            }
            
            var zIndex: Double {
                switch self {
                case .beforePrev,.left: return 0.5
                case .prev: return 0.8
                case .next: return 0.8
                case .afterNext,.right: return 0.5
                case .selected: return 1.0
                case .none: return 0.0
                }
            }
        }
        
        enum Tag: String, Codable {
            case love = "LOVE"
            case daily = "DAILY"
            case ifThe = "IF"
            
            var image: String {
                switch self {
                case .love:
                    return "ios_Tag_img_love"
                case .daily:
                    return "ios_Tag_img_daily"
                case .ifThe:
                    return "ios_Tag_img_if"
                }
            }
        }
    }
}
