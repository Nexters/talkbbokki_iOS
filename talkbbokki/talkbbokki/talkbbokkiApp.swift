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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
//            CardListView(cards: $cards)
            CategoryView(store: Store(initialState: CategoryReducer.State(),
                                      reducer: CategoryReducer()))
        }
    }
}
