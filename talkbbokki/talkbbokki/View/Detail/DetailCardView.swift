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
        static let notReadyAdstoast = "준비된 광고가 없습니다."
        static let topic = "TOPIC"
        static let starter = "STARTER"
        static let alertMessage = "아직 준비중이에요!\n조금만 기다려주세요."
        static let alertConfrimButton = "슬프지만 닫기"
    }
}

struct DetailCardContainerView: View {
    let store: StoreOf<DetailCardReducer>
    let card: Model.Topic
    let color: Int
    let enteredAds: Bool
    let notReadyAds: Bool
    @State private var onAppear: Bool = false
    @State private var backDegree = 0.0
    @State private var frontDegree = -90.0
    @State private var isFlipped = false
    @State private var showToast = false
    
    @State private var didTapDownload = false
    @State private var didTapAlert: ButtonType = .none
    @State private var didTapRefreshOrder = false
    @State private var didTapBookmark = false
    @State private var didTapShare = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let width : CGFloat = 200
    private let height : CGFloat = 250
    private let durationAndDelay : CGFloat = 0.3
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Color(hex: color).ignoresSafeArea()
                if onAppear {
                    DetailFrontCardView(card: card, degree: $backDegree)
                    .transition(.scale.animation(.spring())
                        .combined(with: .move(edge: .bottom)))
                    DetailBackCardView(card: card,
                                       order: viewStore.order,
                                       touchedDownload: $didTapDownload,
                                       touchedRefreshOrder: $didTapRefreshOrder,
                                       touchedBookMark: $didTapBookmark,
                                       degree: $frontDegree,
                                       didTapShare: $didTapShare)
                }
                
                if viewStore.isShowBookMarkAlert {
                    AlertView(message: Design.Text.alertMessage,
                              subMessage: "",
                              buttons: [AlertButton(type: .ok(),
                                                    message: Design.Text.alertConfrimButton)],
                              didTapButton: $didTapAlert)
                    
                }
                
                if notReadyAds && showToast {
                    VStack(alignment: .center) {
                        Spacer()
                        Text(Design.Text.notReadyAdstoast)
                            .padding([.top,.bottom], 5)
                            .padding([.leading,.trailing], 15)
                            .font(.Pretendard.button_small_regular)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(4.0)
                            .padding(.bottom, 20)
                    }.opacity(showToast ? 1.0 : 0.0)
                }
                
                if viewStore.isSuccessSavePhoto {
                    EmoticonAlert(imageName: "heartImg",
                                  message: "이미지 저장 완료!")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            viewStore.send(.setIsSuccessSavePhoto)
                        })
                    }
                }
            }
            .onChange(of: didTapDownload, perform: { newValue in
                viewStore.send(.like(card))
                viewStore.send(.savePhoto(card))
            })
            .onChange(of: didTapAlert, perform: { newValue in
                guard didTapAlert != .none else { return }
                viewStore.send(.showBookMarkAlert)
                didTapAlert = .none
            })
            .onChange(of: didTapRefreshOrder, perform: { newValue in
                viewStore.send(.fetchOrder)
            })
            .onChange(of: didTapBookmark, perform: { newValue in
                viewStore.send(.showBookMarkAlert)
            })
            .onChange(of: didTapShare, perform: { newValue in
                viewStore.send(.like(card))
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .onAppear(perform: {
                showToastAds()
                viewStore.send(.addViewCount(card))
                viewStore.send(.saveTopic(card))
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
    
    private func showToastAds() {
        if notReadyAds {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                withAnimation {
                    showToast.toggle()
                }
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                withAnimation {
                    showToast.toggle()
                }
            })
        }
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("Icon-arrow2_left-24")
        }
    }
    
    //MARK: Flip Card Function
    private func flipCard () {
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
    @Binding var touchedDownload: Bool
    @Binding var touchedRefreshOrder: Bool
    @Binding var touchedBookMark: Bool
    @Binding var degree : Double
    @Binding var didTapShare: Bool
    
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
        .sheet(isPresented: $didTapShare) {
            ActivityViewController(activityItems: [card.pcLink+"&rule=\((order?.id).orZero)"])
        }
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
                .foregroundColor(.Talkbbokki.GrayScale.gray5)
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
            HStack(alignment: .center, spacing: 4) {
                Text(Design.Text.starter)
                    .font(.Pretendard.b2_regular)
                    .foregroundColor(.Talkbbokki.GrayScale.gray5)
                Button {
                    touchedRefreshOrder.toggle()
                } label: {
                    Image("refresh")
                }
                Spacer()
            }
            Text((order?.rule).orEmpty)
                .font(.Pretendard.b1_bold)
                .foregroundColor(.Talkbbokki.GrayScale.black)
        }.padding([.top, .leading, .trailing, .bottom], 24)
    }

    private var buttons: some View {
        HStack(alignment: .center, spacing: .zero) {
            Button {
                didTapShare.toggle()
            } label: {
                Image("shareButton")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            Divider()
            Button {
                touchedDownload.toggle()
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
                                             reducer: DetailCardReducer(topic: Model.Topic(cardNumber: 0,
                                                                                           topicID: 1,
                                                                                           name: "밥 먹다가 체함",
                                                                                           viewCount: 20,
                                                                                           createAt: "1101",
                                                                                           category: "LOVE",
                                                                                           pcLink: "",
                                                                                           tag: .love))),
                                card: Model.Topic(cardNumber: 0,
                                                  topicID: 1,
                                                  name: "밥 먹다가 체함",
                                                  viewCount: 20,
                                                  createAt: "1101",
                                                  category: "LOVE",
                                                  pcLink: "",
                                                  tag: .love),
                                color: 00,
                                enteredAds: false, notReadyAds: true)
    }
}
