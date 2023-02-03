//
//  talkbbokkiApp.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/01/23.
//

import SwiftUI

@main
struct talkbbokkiApp: App {
    @State var cards: [Model.Card] = [
        Model.Card(id: 0, name: "aaaa"),
        Model.Card(id: 1, name: "bbb"),
        Model.Card(id: 2, name: "ccc"),
        Model.Card(id: 3, name: "ddd"),
        Model.Card(id: 4, name: "eee"),
        Model.Card(id: 5, name: "ff"),
        Model.Card(id: 6, name: "gggg")
    ]
    
    var body: some Scene {
        WindowGroup {
            CardListView(cards: $cards)
        }
    }
}
