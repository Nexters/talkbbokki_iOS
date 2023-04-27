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
        case settingNickName
        case home
    }
    
    @State private var scene: ViewScene = .splash
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("nickName") var nickName: String = UserDefaultValue.nickName
    @AppStorage("didShowOnboard") var didShowOnboard: Bool = UserDefaultValue.didShow
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch scene {
                case .splash:
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                                if didShowOnboard == false {
                                    scene = .onboard
                                } else if nickName.isEmpty {
                                    scene = .settingNickName
                                } else {
                                    scene = .home
                                }
                            })
                        }
                case .onboard:
                    OnboardView()
                case .settingNickName:
                    NicknameSettingView(store: .init(initialState: .init(), reducer: NickNameSettingReducer()))
                case .home:
                    CategoryView(store: Store(initialState: CategoryReducer.State(),
                                              reducer: CategoryReducer()))
                }
            }.onChange(of: didShowOnboard) { newValue in
                scene = nickName.isEmpty ? .settingNickName : .home
            }
        }
    }
}
