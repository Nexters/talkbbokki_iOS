//
//  CardListView.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//
import UIKit
import SwiftUI
import Combine

private enum Design {
    enum Constraint {
        struct CardView {
            static let width: CGFloat = 110
        }
        
        struct CardListView {
            static let spacing: CGFloat = -50
        }
    }
}


struct CardListView: View {
    @State private var cards: [Model.Card]? = [Model.Card(id: 0,
                                                         name: "aaa"),
                                              Model.Card(id: 1,
                                                         name: "bbb"),
                                              Model.Card(id: 2,
                                                         name: "ccc"),
                                              Model.Card(id: 3,
                                                         name: "ddd"),
                                              Model.Card(id: 4,
                                                         name: "ddd"),
                                              Model.Card(id: 5,
                                                         name: "ddd")]
    private let viewModel = CardListViewModel()

    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                CardContainerView(cards: $cards)
                Spacer()
            }.animation(.spring())
        }.onAppear {
//            cards = [Model.Card(id: 0,
//                                name: "aaa"),
//                     Model.Card(id: 1,
//                                name: "bbb"),
//                     Model.Card(id: 2,
//                                name: "ccc"),
//                     Model.Card(id: 3,
//                                name: "ddd"),
//                     Model.Card(id: 4,
//                                name: "ddd"),
//                     Model.Card(id: 5,
//                                name: "ddd")]
            viewModel.start()
        }
    }
}

struct CardContainerView: View {
    private let width: Double = Design.Constraint.CardView.width
    private let spacing: CGFloat = Design.Constraint.CardListView.spacing
    @State private var offsetX: Double = 0
    @State private var x: CGFloat = 0
    @State private var currentIndex: Int = -1
    @Binding var cards: [Model.Card]?
    
    var body: some View {
        HStack(spacing: spacing){
            ForEach(cards ?? []){ cardData in
                CardView(card: cardData)
                    .zIndex(cardData.position.zIndex)
                    .offset(x: self.x, y: cardData.position.positionY)
                    .highPriorityGesture(DragGesture()
                        .onChanged({ (value) in
                            if value.translation.width > 0{
                                self.x = value.location.x
                            }
                            else{
                                self.x = value.location.x - self.width
                            }
                        })
                            .onEnded({ (value) in
                                if value.translation.width > 0{
                                    if value.translation.width > ((self.width) / 2) && Int(self.currentIndex) != 0{
                                        self.currentIndex -= 1
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                    else{
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                }
                                else{
                                    if -value.translation.width > ((self.width) / 2) && Int(self.currentIndex) !=  ((cards?.count).orZero - 1){
                                        self.currentIndex += 1
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                    else {
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                }
                            })
                    ).onChange(of: self.currentIndex) { index in
                        let differ = cardData.id - index
                        switch differ {
                        case 0:
                            cards?[cardData.id].position = .selected
                        case -1:
                            cards?[cardData.id].position = .prev
                        case -2:
                            cards?[cardData.id].position = .beforePrev
                        case 1:
                            cards?[cardData.id].position = .next
                        case 2:
                            cards?[cardData.id].position = .afterNext
                        case _ where differ > 0:
                            cards?[cardData.id].position = .right
                        case _ where differ < 0:
                            cards?[cardData.id].position = .left
                        default:
                            cards?[cardData.id].position = .none
                        }
                    }
            }
        }
        .offset(x: offsetX)
        .onAppear {
            currentIndex = 0
            offsetX = ((self.width + spacing) * CGFloat((cards?.count).orZero / 2)) - ((cards?.count).orZero % 2 == 0 ? ((self.width + spacing) / 2) : 0)
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
