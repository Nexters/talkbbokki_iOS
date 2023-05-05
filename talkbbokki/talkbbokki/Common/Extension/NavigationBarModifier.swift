//
//  NavigationBarModifier.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import SwiftUI
import UIKit

struct NavigationBarModifier: ViewModifier {
    let backgroundColor: Color?
    init(backgroundColor: Color?, titleColor: Color?, font: Font? = nil) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = UIColor(backgroundColor ?? .clear)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(titleColor ?? .white)]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(titleColor ?? .white)]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        if let uiFont = font?.preferredFont() {
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : uiFont]
        }
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    (backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBar(backgroundColor: Color? = nil, titleColor: Color?, font: Font? = nil) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor, font: font))
    }
}
