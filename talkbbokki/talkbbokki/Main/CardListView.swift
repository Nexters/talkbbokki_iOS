//
//  CardListView.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//
import UIKit
import SwiftUI

struct CardListView: View {
    private let width = UIScreen.main.bounds.width - 100
    @Binding var cards: [Model.Card]
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                CardContainerView(width: width, cards: $cards)
                Spacer()
            }.animation(.spring())
        }.onAppear {
            API.Category().request().sink { completion in
                
            } receiveValue: { isAble in
                
            }

        }
    }
}

struct CardContainerView: View {
    let width: Double
    private let spacing: CGFloat = 10
    @State private var offsetX: Double = 0
    @State private var x: CGFloat = 0
    @State private var currentIndex: Int = -1
    @Binding var cards: [Model.Card]
    
    var body: some View {
        HStack(spacing: spacing){
            ForEach(cards){ cardData in
                CardView(width: width,
                         height: 500,
                         card: cardData)
                    .zIndex(cardData.position == .selected ? 1.0 : 0.0)
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
                                    if -value.translation.width > ((self.width) / 2) && Int(self.currentIndex) !=  (self.cards.count - 1){
                                        self.currentIndex += 1
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                    else {
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                }
                            })
                    ).onChange(of: self.currentIndex) { index in
                        if cardData.id == index {
                            cards[cardData.id].position = .selected
                        } else if cardData.id == index-1 {
                            cards[cardData.id].position = .prev
                        } else if cardData.id == index+1 {
                            cards[cardData.id].position = .next
                        } else {
                            cards[cardData.id].position = .none
                        }
                    }
            }
        }
        .offset(x: offsetX)
        .onAppear {
            currentIndex = 0
            offsetX = ((self.width + spacing) * CGFloat(self.cards.count / 2)) - (self.cards.count % 2 == 0 ? ((self.width + spacing) / 2) : 0)
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView(cards: .constant([Model.Card(id: 0,
                                                  name: "aaa"),
                                       Model.Card(id: 0,
                                                  name: "aaa"),
                                       Model.Card(id: 0,
                                                  name: "aaa"),
                                       Model.Card(id: 0,
                                                  name: "aaa")
        ]))
    }
}
