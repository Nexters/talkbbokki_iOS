//
//  Color.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/14.
//

import SwiftUI

extension Color {
    struct Talkbbokki {
        struct Primary {
            static var mainColor1: Color {
                Color(hex: 0xFF7490)
            }
            
            static var mainColor2: Color {
                Color(hex: 0x1A1A1A)
            }
        }
        
        struct Accent {
            static var category01: Color {
                Color(hex: 0x9C5FFF)
            }
            
            static var category02: Color {
                Color(hex: 0x1EAC90)
            }
            
            static var category03: Color {
                Color(hex: 0xFBB21E)
            }
        }
        
        struct GrayScale {
            static var black: Color {
                Color(hex: 0x000000)
            }
            
            static var gray7: Color {
                Color(hex: 0x1A1A1A)
            }
            
            static var gray6: Color {
                Color(hex: 0x555555)
            }
            
            static var gray5: Color {
                Color(hex: 0x8B8B8B)
            }
            
            static var gray4: Color {
                Color(hex: 0xBABABA)
            }
            
            static var gray3: Color {
                Color(hex: 0xE2E2E2)
            }
            
            static var white: Color {
                Color(hex: 0xFFFFFF)
            }
        }
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension String {
    var color: Int {
        var temp = self
        if (self.hasPrefix("#")) {
            temp.removeFirst()
        }
        
        temp = "0x"+temp
        var rgbValue: UInt64 = 0
        Scanner(string: temp).scanHexInt64(&rgbValue)
        return Int(rgbValue)
    }
}
