//
//  DetailCardView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import SwiftUI
import ComposableArchitecture

private enum Design {
    enum Constraint {
        static let originCardSize = CGSize(width: 100, height: 200)
        static let cardSize = CGSize(width: 320, height: 454)
        static let imageSize: CGSize = CGSize(width: 259, height: 402)
    }
    
    enum Text {
        static let topic = "TOPIC"
        static let starter = "STARTER"
    }
}

struct DetailCardContainerView: View {
    let store: StoreOf<DetailCardReducer>
    let card: Model.Topic
    @State private var backgroundOpacity: CGFloat = 0.0
    @State private var onAppear: Bool = false
    @State private var backDegree = 0.0
    @State private var frontDegree = -90.0
    @State private var isFlipped = false
    
    @State private var didTapRefreshOrder = false
    @State private var didTapBookmark = false
    private let width : CGFloat = 200
    private let height : CGFloat = 250
    private let durationAndDelay : CGFloat = 0.3
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color.purple.ignoresSafeArea()
                if onAppear {
                    DetailFrontCardView(card: card, degree: $backDegree)
                    .transition(.scale.animation(.spring())
                        .combined(with: .move(edge: .bottom)))
                    DetailBackCardView(card: card,
                                       order: viewStore.order,
                                       touchedRefreshOrder: $didTapRefreshOrder,
                                       touchedBookMark: $didTapBookmark,
                                       degree: $frontDegree)
                }
            }
            .onChange(of: didTapRefreshOrder, perform: { newValue in
                viewStore.send(.fetchOrder)
            })
            .onAppear(perform: {
                viewStore.send(.fetchOrder)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    withAnimation(.spring(dampingFraction: 0.7, blendDuration: 0.9)) {
                        onAppear.toggle()
                    }
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    flipCard()
                })
            })
        }
    }
    
    //MARK: Flip Card Function
    func flipCard () {
        isFlipped.toggle()
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
}


struct DetailFrontCardView: View {
    let card : Model.Topic
    @Binding var degree : Double
    var body : some View{
        ZStack {
            card.position.background
                .resizable()
                .frame(width: Design.Constraint.cardSize.width,
                       height: Design.Constraint.cardSize.height)
            Image(card.tag.image)
                .resizable()
                .frame(width: Design.Constraint.imageSize.width,
                       height: Design.Constraint.imageSize.height)
        }
        .frame(width: Design.Constraint.cardSize.width,
               height: Design.Constraint.cardSize.height)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct DetailBackCardView: View {
    let card : Model.Topic
    let order: Model.Order?
    @Binding var touchedRefreshOrder: Bool
    @Binding var touchedBookMark: Bool
    @Binding var degree : Double
    var body : some View{
        ZStack {
            backgroundView
            VStack(alignment: .leading, spacing: 0){
                content
                Divider()
                starterGuideView
                Divider()
                buttons
            }
        }
        .frame(width: Design.Constraint.cardSize.width,
               height: Design.Constraint.cardSize.height)
        .cornerRadius(12)
        .shadow(radius: 12)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
    
    private var backgroundView: some View {
        Color.white
            .frame(width: Design.Constraint.cardSize.width,
                   height: Design.Constraint.cardSize.height)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleView
            Text(card.name).font(.Pretendard.b1_bold).foregroundColor(.black)
            Spacer()
        }
        .padding([.top, .leading, .trailing], 24)
    }
    
    private var titleView: some View {
        HStack {
            Text(Design.Text.topic)
                .font(.Pretendard.b2_regular)
            Spacer()
            Button {
                touchedBookMark.toggle()
            } label: {
                Image("emptyBookMark")
            }
        }
    }
    
    private var starterGuideView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text(Design.Text.starter).font(.Pretendard.b2_regular)
                Button {
                    touchedRefreshOrder.toggle()
                } label: {
                    Image("refresh")
                }
                Spacer()
            }
            Text((order?.rule).orEmpty).font(.Pretendard.b1_bold)
        }.padding([.top, .leading, .trailing, .bottom], 24)
    }
    
    private var buttons: some View {
        HStack {
            Button {
                
            } label: {
                Image("shareButton")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            Divider()
            Button {
                
            } label: {
                Image("downloadButton")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }.frame(height: 60)
    }
}

struct DetailCardContainerView_Preview: PreviewProvider {
    static var previews: some View {
        DetailCardContainerView(store: Store(initialState: DetailCardReducer.State(),
                                             reducer: DetailCardReducer()),
                                card: Model.Topic(cardNumber: 0,
                                                  topicID: 1,
                                                  name: "밥 먹다가 체함",
                                                  viewCount: 20,
                                                  createAt: "1101",
                                                  category: "LOVE",
                                                  pcLink: "",
                                                  tag: .love))
    }
}
