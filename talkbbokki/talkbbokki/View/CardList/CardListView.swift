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
            static let cardX: CGFloat = 65
        }
        
        struct CardListView {
            static let spacing: CGFloat = -55
        }
    }
    
    enum Text {
        static let alreadyShowCard = "이 카드 다시 뽑기"
        static let shouldAds = "광고 보고 카드 뽑기"
        static let confirm = "이 카드 뽑기"
        static let subTitle = "하는 사이라면"
        static let finishedCardButton = "안녕하고 닫기"
        static let finishedCardMessage = "오늘 준비한 카드를 모두 뽑았어요\n내일 다시 만나요 :)"
    }
}


struct CardListView: View {
    let category: Model.Category
    let store: StoreOf<CardListReducer>
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var didTapFinishedAlert: ButtonType = .none
    @State private var didTapDetailCard: ButtonType = .none
    @State private var didAppear = false
    @ObservedObject var adViewModel = AdViewModel()
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                NavigationView {
                    ZStack(alignment: .topLeading) {
                        Color(hex: category.bgColor.color)
                            .ignoresSafeArea()
                        
                        Group {
                            VStack {
                                Spacer()
                                CardContainerView(offsetX:viewStore.offsetX,
                                                  shouldAds: isAbleAds(viewCount: viewStore.viewCount,
                                                                       didShowTopicIds: viewStore.didShowTopicIds,
                                                                       currentTopic: viewStore.topics[safe: viewStore.currentIndex]),
                                                  currentIndex: viewStore.binding(
                                                    get: \.currentIndex,
                                                    send: { .changedCurrentIndex($0) }
                                                  ),
                                                  touchedCard: $didTapDetailCard,
                                                  didShowTopicIds: viewStore.didShowTopicIds,
                                                  cards: viewStore.topics)
                                Spacer()
                            }
                            
                            VStack(alignment: .leading) {
                                closeButton
                                CardListTitleView(title: category.firstLineTitle,
                                                  subTitie: category.secondLineTitle)
                                Spacer()
                                
                                NavigationLink(isActive:
                                                viewStore.binding(get: \.isShowDetailCard,
                                                                  send: { .setShowDetailCardReducer($0) })
                                ) {
                                    IfLetStore(self.store.scope(state: \.detailCardState,
                                                                action: { .detailCardDelegate($0)
                                    })) {
                                        DetailCardContainerView(store: $0,
                                                                color: category.bgColor.color,
                                                                notReadyAds: adViewModel.notReadyAds,
                                                                isEnteredModal: false
                                        )
                                    }
                                } label: {
                                        confirmButton(didShowTopicIds: viewStore.didShowTopicIds,
                                                      isAbleAds: isAbleAds(viewCount: viewStore.viewCount,
                                                                           didShowTopicIds: viewStore.didShowTopicIds,
                                                                           currentTopic: viewStore.topics[safe: viewStore.currentIndex]),
                                                      currentTopic: viewStore.topics[safe: viewStore.currentIndex])
                                }
                            }
                        }
                        .frame(width: proxy.size.width,
                               height: proxy.size.height, alignment: .topLeading)
                        .animation(.interactiveSpring(response: 0.3))
                        .onChange(of: didTapDetailCard, perform: { newValue in
                            guard didTapDetailCard != .none else { return }
                            if isAbleAds(viewCount: viewStore.viewCount,
                                         didShowTopicIds: viewStore.didShowTopicIds,
                                         currentTopic: viewStore.topics[safe: viewStore.currentIndex]) {
                                adViewModel.loadAd()
                            } else {
                                viewStore.send(.setShowDetailCardReducer(true))
                            }
                            didTapDetailCard = .none
                        })
                        .onChange(of: adViewModel.ad, perform: { newValue in
                            adViewModel.presentAd(from: adViewControllerRepresentable.viewController)
                        })
                        .onChange(of: adViewModel.dismissAd, perform: { newValue in
                            viewStore.send(.setShowDetailCardReducer(true))
                        })
                        .onAppear {
                            if didAppear == false {
                                viewStore.send(.fetchCard(category: category.code))
                                didAppear = true
                            }
                            viewStore.send(.fetchViewCount)
                            viewStore.send(.fetchDidShowTopics)
                        }
                        
                        if (viewStore.topics
                            .map { $0.topicID }
                            .filter { viewStore.didShowTopicIds.contains($0) }
                            .count == viewStore.topics.count)
                            && viewStore.topics.count > 0
                            && didTapFinishedAlert == .none {
                            AlertView(message: Design.Text.finishedCardMessage,
                                      subMessage: "",
                                      buttons: [AlertButton(type: .ok(), message: Design.Text.finishedCardButton)],
                                      didTapButton: $didTapFinishedAlert)
                            .zIndex(0)
                        }
                    }
                    .navigationBarHidden(true)
                }
            }.background(adViewControllerRepresentable
                .frame(width: .zero, height: .zero))
        }
    }

    private func confirmButton(didShowTopicIds: [Int],
                               isAbleAds: Bool,
                               currentTopic: Model.Topic?) -> some View {
        let didShow = didShowTopicIds.contains { $0 == (currentTopic?.topicID).orZero }
        var message = ""
        switch (isAbleAds, didShow) {
        case (true, _):
            message = Design.Text.shouldAds
        case (_, true):
            message = Design.Text.alreadyShowCard
        case (_, false):
            message = Design.Text.confirm
        }
        return ConfirmButtonView(didTapConfirm: $didTapDetailCard,
                                 type: .ok(),
                                 buttonMessage: message)
        .padding([.leading, .trailing], 20)
        .padding(.bottom, 16)
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("close")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(20)
            }
        }
    }
    
    private func isAbleAds(viewCount: Int,
                           didShowTopicIds: [Int],
                           currentTopic: Model.Topic?) -> Bool {
        let didShow = didShowTopicIds.contains { $0 == (currentTopic?.topicID).orZero }
        return viewCount.isAbleAdsCount && !didShow
    }
}

struct CardListTitleView: View {
    let title: String
    let subTitie: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title).font(.Pretendard.h2_bold).foregroundColor(.Talkbbokki.GrayScale.black)
                Text(subTitie+"라면").font(.Pretendard.h2_bold)
                    .foregroundColor(.Talkbbokki.GrayScale.black)
                    .opacity(0.35)
            }
            .padding(.leading, 20)
            Spacer()
        }
    }
}

struct CardContainerView: View {
    let offsetX: Double
    let shouldAds: Bool
    private let width = Design.Constraint.CardView.width
    private let spacing = Design.Constraint.CardListView.spacing
    private let cardX: CGFloat = Design.Constraint.CardView.width + Design.Constraint.CardListView.spacing
    @State private var x: CGFloat = 0
    @Binding var currentIndex: Int
    @Binding var touchedCard: ButtonType
    let didShowTopicIds: [Int]
    let cards: [Model.Topic]
    
    var body: some View {
        HStack(spacing: spacing){
            ForEach(cards){ cardData in
                CardView(shouldAds: shouldAds,
                         didShow: didShowTopicIds.contains { $0 == cardData.topicID },
                         card: cardData)
                    .zIndex(cardData.position.zIndex)
                    .offset(x: self.x, y: cardData.position.positionY)
                    .highPriorityGesture(DragGesture()
                            .onEnded({ (value) in
                                if value.translation.width > 0{
                                    if value.translation.width > ((self.width) / 2) && Int(self.currentIndex) != 0{
                                        self.currentIndex -= 1
                                    }
                                }
                                else{
                                    if -value.translation.width > ((self.width) / 2) && Int(self.currentIndex) !=  (cards.count - 1){
                                        self.currentIndex += 1
                                    }
                                }
                                
                            })
                    ).onTapGesture {
                        touchedCard = .confirm()
                    }
            }
        }
        .onChange(of: currentIndex, perform: { newValue in
            self.x = currentIndex == 0 ? 0 : -(cardX * Double(self.currentIndex)) - 24
        })
        .offset(x: offsetX)
        .onAppear {
            currentIndex = currentIndex == -1 ? 0 : currentIndex
        }
    }
}

extension Int {
    var isAbleAdsCount: Bool {
        return (self > 0 && self%4 == 0)
    }
}
