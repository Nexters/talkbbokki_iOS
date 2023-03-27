//
//  talkbbokkiApp.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/01/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct talkbbokkiApp: App {
    enum ViewScene {
        case splash
        case onboard
        case home
    }
    
    @State private var scene: ViewScene = .splash
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("didShowOnboard") var didShowOnboard : Bool = UserDefaultValue.didShow
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch scene {
                case .splash:
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                                scene = didShowOnboard ? .home : .onboard
                            })
                        }
                case .onboard:
                    OnboardView()
                case .home:
                    CategoryView(store: Store(initialState: CategoryReducer.State(),
                                              reducer: CategoryReducer()))
                }
            }.onChange(of: didShowOnboard) { newValue in
                scene = .home
            }
        }
    }
}
