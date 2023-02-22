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
    let shouldAds: Bool
    let didShow: Bool
    let card : Model.Topic
    
    private var showAlreadyCard: Bool {
        card.position == .selected && didShow && !shouldAds
    }
    
    private var showAdsAlert: Bool {
        card.position == .selected && shouldAds
    }
    var body : some View{
        VStack(spacing: 12) {
            if showAlreadyCard {
                Text("이미 뽑은 카드에요.")
                    .font(.Pretendard.b2_bold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: -27) {
                if showAdsAlert {
                    VStack(alignment: .center, spacing: -1) {
                        Text("4개부터는 광고를\n보면 뽑을 수 있어요")
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .font(.Pretendard.b3_regular)
                            .foregroundColor(.white)
                            .padding([.top,.bottom], 8)
                            .padding([.leading,.trailing], 16)
                            .background(Color.Talkbbokki.GrayScale.gray7)
                            .cornerRadius(8)
                        Image("Polygon")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                    .zIndex(1)
                }
                ZStack {
                    card.position.background
                    Image(card.tag.image)
                        .resizable()
                        .frame(width: Design.Constraint.imageSize.width,
                               height: Design.Constraint.imageSize.height)
                        .opacity(card.position == .selected ? 1.0 : 0.0)
                }
            }
        }
        .frame(width: card.position.size.width, height: card.position.size.height)
        .rotationEffect(Angle(degrees: card.position.degree))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(shouldAds: true,
                 didShow: false,
                 card: Model.Topic(cardNumber: 0,
                                   topicID: 0,
                                   name: "ddd",
                                   viewCount: 11,
                                   createAt: "",
                                   category: "",
                                   pcLink: "",
                                   tag: .love))
    }
}
