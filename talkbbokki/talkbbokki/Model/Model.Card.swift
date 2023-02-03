//
//  Model.Card.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//

import Foundation

extension Model {
    struct Card : Identifiable {
        var id : Int
        var name : String
        var degree: Double = 0.0
        var position: Position = .none
        
        enum Position {
            case prev
            case selected
            case next
            case none
            var degree: Double {
                switch self {
                case .prev: return -15.0
                case .next: return 15.0
                case .selected: return 0.0
                case .none: return 0.0
                }
            }
            
            var positionY: Double {
                switch self {
                case .prev: return 50.0
                case .next: return 50.0
                case .selected: return 0.0
                case .none: return 0.0
                }
            }
        }
    }
}
