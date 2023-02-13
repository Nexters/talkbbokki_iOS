//
//  CardView.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//

import SwiftUI

struct CardView: View {
    let card : Model.Topic
    var body : some View{
        ZStack {
            card.position.background
            VStack(alignment: .center, spacing: 0){
                Image("cardImage")
                Text(card.tag)
                    .foregroundColor(.black)
                    .font(.Pretendard.h2_bold)
                HStack(spacing: 0) {
                    Text("\(card.viewCount)").font(.Pretendard.b2_bold).foregroundColor(.black)
                    Text("명의 PICK!").font(.Pretendard.b2_bold).foregroundColor(.black)
                }
            }
            .opacity(card.position == .selected ? 1.0 : 0.0)
        }
        .frame(width: card.position.size.width, height: card.position.size.height)
        .rotationEffect(Angle(degrees: card.position.degree))
    }
}
