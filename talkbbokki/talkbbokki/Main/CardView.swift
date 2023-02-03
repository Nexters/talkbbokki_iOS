//
//  CardView.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//

import SwiftUI

struct CardView: View {
    let width: CGFloat
    let height: CGFloat
    var card : Model.Card
    var body : some View{
        VStack(alignment: .leading, spacing: 0){
            Text(card.name)
                .fontWeight(.bold)
                .padding(.vertical, 13)
                .padding(.leading)
            
        }
        .frame(width: width, height: height)
        .background(Color.red)
        .cornerRadius(25)
        .rotationEffect(Angle(degrees: card.position.degree))
    }
}
