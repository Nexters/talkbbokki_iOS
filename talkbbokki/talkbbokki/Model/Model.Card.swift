//
//  Model.Card.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//

import Foundation
import SwiftUI
extension Model {
    struct Card : Identifiable {
        var id : Int
        var name : String
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
                case .selected: return CGSize(width: 223, height: 314)
                case .none: return CGSize(width: 50, height: 50)
                }
            }
            
            var color: Color {
                switch self {
                case .beforePrev,.left: return .blue
                case .prev: return .yellow
                case .next: return .yellow
                case .afterNext,.right: return .blue
                case .selected: return .red
                case .none: return .green
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
    }
}
