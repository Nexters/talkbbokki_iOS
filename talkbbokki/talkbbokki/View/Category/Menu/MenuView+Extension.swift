//
//  MenuView+Extension.swift
//  talkbbokki
//
//  Created by USER on 2023/05/03.
//

import Foundation

extension MenuView {
    enum TapAction: Equatable {
        case editNickName(String)
        case favorite
        case suggest
        case close
        case none
    }
    
    enum BottomComponent: Identifiable, Equatable {
        case favorite
        case suggest
        
        var id: String {
            return name
        }
        
        var name: String {
            switch self {
            case .favorite: return "즐겨찾기한 주제"
            case .suggest: return "주제 제안하기"
            }
        }
    }
}
