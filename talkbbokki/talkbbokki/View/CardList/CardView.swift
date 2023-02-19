//
//  CardView.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//

import SwiftUI
private enum Design {
    enum Constraint {
        static let imageSize: CGSize = CGSize(width: 159, height: 250)
    }
}

struct CardView: View {
    let card : Model.Topic
    var body : some View{
        ZStack {
            card.position.background
            Image(card.tag.image)
                .resizable()
                .frame(width: Design.Constraint.imageSize.width, height: Design.Constraint.imageSize.height)
            .opacity(card.position == .selected ? 1.0 : 0.0)
        }
        .frame(width: card.position.size.width, height: card.position.size.height)
        .rotationEffect(Angle(degrees: card.position.degree))
    }
}
