//
//  Font+.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import SwiftUI

extension Font {
    struct Pretendard {
        static var h1: Font {
            .custom("Pretendard-Bold", size: 40)
        }
        
        static var h2_bold: Font {
            .custom("Pretendard-Bold", size: 28)
        }
        
        static var h2_regular: Font {
            .custom("Pretendard-Regular", size: 28)
        }
        
        static var b1_bold: Font {
            .custom("Pretendard-Bold", size: 20)
        }
        
        static var b1_regular: Font {
            .custom("Pretendard-Regular", size: 20)
        }
        
        static var b2_bold: Font {
            .custom("Pretendard-Bold", size: 16)
        }
        
        static var b2_regular: Font {
            .custom("Pretendard-Regular", size: 16)
        }
        
        static var b3_bold: Font {
            .custom("Pretendard-Bold", size: 14)
        }
        
        static var b3_regular: Font {
            .custom("Pretendard-Regular", size: 14)
        }
        
        static var caption1: Font {
            .custom("Pretendard-Regular", size: 12)
        }
        
        static var reply: Font {
            .custom("Pretendard-Bold", size: 12)
        }
        
        static var button_large: Font {
            .custom("Pretendard-Bold", size: 18)
        }
        
        static var button_small_bold: Font {
            .custom("Pretendard-Bold", size: 14)
        }
        
        static var button_small_regular: Font {
            .custom("Pretendard-Regular", size: 14)
        }
    }
}

extension Font {
    func preferredFont() -> UIFont? {
        switch self {
        case .Pretendard.h1: return UIFont(name: "Pretendard-Bold", size: 40)
        case .Pretendard.h2_regular: return UIFont(name: "Pretendard-Regular", size: 28)
        case .Pretendard.b1_bold: return UIFont(name: "Pretendard-Bold", size: 20)
        case .Pretendard.b1_regular: return UIFont(name: "Pretendard-Regular", size: 20)
        case .Pretendard.b2_bold: return UIFont(name: "Pretendard-Bold", size: 16)
        case .Pretendard.b2_regular: return UIFont(name: "Pretendard-Regular", size: 16)
        case .Pretendard.b3_bold: return UIFont(name: "Pretendard-Bold", size: 14)
        case .Pretendard.b3_regular: return UIFont(name: "Pretendard-Regular", size: 14)
        case .Pretendard.caption1: return UIFont(name: "Pretendard-Regular", size: 12)
        case .Pretendard.button_large: return UIFont(name: "Pretendard-Bold", size: 18)
        case .Pretendard.button_small_bold: return UIFont(name: "Pretendard-Bold", size: 14)
        case .Pretendard.button_small_regular: return UIFont(name: "Pretendard-Regular", size: 14)
        default: return nil
        }
    }
}
