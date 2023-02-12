//
//  CardListView.swift
//  talkbbokki
//
//  Created by USER on 2023/01/29.
//
import UIKit
import SwiftUI
import ComposableArchitecture
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
    
    enum Text {
        static let confirm = "이 카드 뽑기"
        static let subTitle = "하는 사이라면"
    }
}


struct CardListView: View {
    let category: Model.Category
    let store: StoreOf<CardListReducer>
    @Environment(\.presentationMode) private var presentationMode
    @State private var currentIndex: Int = -1

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                NavigationView{
                    ZStack(alignment: .topLeading) {
                        Color.purple.ignoresSafeArea()
                        
                        VStack(alignment: .leading) {
                            closeButton
                            CardListTitleView(title: category.text)
                            Spacer()
                            CardContainerView(offsetX:viewStore.offsetX,
                                              currentIndex: $currentIndex,
                                              cards: viewStore.topics)
                            Spacer()
                            NavigationLink(destination: presentDetailCardView) {
                                ConfirmText(buttonMessage: Design.Text.confirm)
                            }
                        }
                        .frame(width: proxy.size.width,
                               height: proxy.size.height, alignment: .topLeading)
                        .animation(.interactiveSpring(response: 0.3))
                        .onChange(of: currentIndex, perform: { newValue in
                            viewStore.send(.changedCurrentIndex(currentIndex))
                        })
                        .onAppear {
                            viewStore.send(.fetchCard(category: category.code))
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var presentDetailCardView: some View {
//        if let pickCard = cards?[safe:currentIndex] {
//            DetailCardView(card: pickCard)
//        } else {
            EmptyView()
//        }
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(20)
            }
        }
    }
}

struct CardListTitleView: View {
    let title: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title).font(.Pretendard.h2_bold)
                Text(Design.Text.subTitle).font(.Pretendard.h2_bold)
            }
            .padding(.leading, 20)
            Spacer()
        }
    }
}

struct CardContainerView: View {
    let offsetX: Double
    private let width: Double = Design.Constraint.CardView.width
    private let spacing: CGFloat = Design.Constraint.CardListView.spacing
    @State private var x: CGFloat = 0
    @Binding var currentIndex: Int
    let cards: [Model.Topic]
    
    var body: some View {
        HStack(spacing: spacing){
            ForEach(cards){ cardData in
                CardView(size: cardData.position.size,
                         card: cardData)
                    .zIndex(cardData.position.zIndex)
                    .offset(x: self.x, y: cardData.position.positionY)
                    .highPriorityGesture(DragGesture()
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
                                    if -value.translation.width > ((self.width) / 2) && Int(self.currentIndex) !=  (cards.count - 1){
                                        self.currentIndex += 1
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                    else {
                                        self.x = -((self.width + spacing) * Double(self.currentIndex))
                                    }
                                }
                            })
                    )
            }
        }
        .offset(x: offsetX)
        .onAppear {
            currentIndex = currentIndex == -1 ? 0 : currentIndex
        }
    }
}
