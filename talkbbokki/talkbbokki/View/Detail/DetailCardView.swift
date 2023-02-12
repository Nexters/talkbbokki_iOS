//
//  DetailCardView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import SwiftUI

struct DetailCardView: View {
    let card: Model.Topic
    @State private var backgroundOpacity: CGFloat = 0.0
    @State private var cardSize: CGSize = CGSize.zero
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CardView(size: cardSize,
                     card: card)
                .frame(width: cardSize.width,
                       height: cardSize.height)
        }.onAppear(perform: {
            withAnimation(.spring()) {
                backgroundOpacity = 1.0
                cardSize = card.position.size
            }
        })
    }
}
