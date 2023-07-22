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

private enum Constant {
    static let viewCount = 5.0
}

struct DetailCardContainerView: View {
    let store: StoreOf<DetailCardReducer>
    let color: Int
    let notReadyAds: Bool
    let isEnteredModal: Bool

    @State private var didLoad: Bool = false
    @State private var backDegree = 0.0
    @State private var frontDegree = -90.0
    @State private var isFlipped = false
    @State private var isFlipping = false
    @State private var showToast = ""
    
    @State private var didTapDownload = false
    @State private var didTapAlert: ButtonType = .none
    @State private var didTapRefreshOrder = false
    @State private var didTapBookmark = false
    @State private var didTapShare = false
    @State private var didTapComment = false
    @ObservedObject private var adViewModel = AdViewModel()
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    private let width : CGFloat = 200
    private let height : CGFloat = 250
    private let durationAndDelay : CGFloat = 0.3
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color(hex: color).ignoresSafeArea()
                if isEnteredModal {
                    closeButton.zIndex(0)
                }
                
                ZStack(alignment: .top) {
                    if didLoad {
                        Group {
                            VStack {
                                Spacer()
                                ZStack {
                                    DetailFrontCardView(card: viewStore.card, degree: $backDegree)
                                    DetailBackCardView(card: viewStore.card,
                                                       order: viewStore.order,
                                                       isSaveTopic: viewStore.isSaveTopic,
                                                       touchedDownload: $didTapDownload,
                                                       touchedRefreshOrder: $didTapRefreshOrder,
                                                       touchedBookMark: $didTapBookmark,
                                                       degree: $frontDegree,
                                                       didTapShare: $didTapShare)
                                }
                                Spacer()
                            }
                        }
                        .transition(.presentCardTransition)
                    }
                    
                    if viewStore.toastMessage.isNonEmpty {
                        VStack {
                            Spacer()
                            ToastView(message: viewStore.toastMessage)
                                .offset(y: -20.0)
                                .opacity(viewStore.toastMessage.isNonEmpty ? 1.0 : 0.0)
                                .transition(.opacity.animation(.easeOut))
                        }
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
                .ignoresSafeArea()

                bottomView(isHiddenPrevNextButton: viewStore.cards.count == 1,
                           count: viewStore.commentCount,
                           isLeftMost: viewStore.isLeftmost,
                           isRightMost: viewStore.isRightMost
                ) {
                    viewStore.send(.setShowComment(true))
                } didTapNext: {
                    changeCard {
                        viewStore.send(.setSelectedIndex(viewStore.selectedIndex+1))
                    }
                } didTapPrev: {
                    changeCard {
                        viewStore.send(.setSelectedIndex(viewStore.selectedIndex-1))
                    }
                }
                
                NavigationLink(isActive: viewStore.binding(get: \.showComment,
                                                           send: { .setShowComment($0) })) {
                    IfLetStore(self.store.scope(state: \.commentState,
                                                action: { .commentDelegate($0)
                    })) {
                        CommentListView(store: $0)
                    }
                } label: {}
                    .navigationBar(titleColor: Color.Talkbbokki.GrayScale.white,
                                   font: .Pretendard.b2_bold)
            }
            .background(
                adViewControllerRepresentable
                    .frame(width: .zero, height: .zero)
            )
            .onChange(of: didTapDownload, perform: { newValue in
                Log.Firebase.sendLog(key: .click_card_download, parameters: ["topic_id": viewStore.card.topicID.toString])
                viewStore.send(.savePhoto(viewStore.card))
            })
            .onChange(of: didTapRefreshOrder, perform: { newValue in
                viewStore.send(.fetchOrder)
            })
            .onChange(of: didTapBookmark, perform: { newValue in
                Log.Firebase.sendLog(key: .click_card_bookmark, parameters: ["topic_id": viewStore.card.topicID.toString])
                viewStore.send(.didTapBookMark(viewStore.card, color))
            })
            .onChange(of: didTapShare, perform: { newValue in
                Log.Firebase.sendLog(key: .click_card_share, parameters: ["topic_id": viewStore.card.topicID.toString])
            })
            .onChange(of: viewStore.toastMessage, perform: { newValue in
                guard newValue.isNonEmpty else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    viewStore.send(.setToastMessage(""))
                })
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .onChange(of: viewStore.viewCount, perform: { newValue in
                if newValue.isAbleAdsCount {
                    adViewModel.loadAd {
                        adViewModel.presentAd(from: adViewControllerRepresentable.viewController)
                    }
                }
            })
            .onAppear(perform: {
                guard didLoad == false else { return }
                Log.Firebase.sendLog(key: .screen_card_detail, parameters: ["topic_id": viewStore.card.topicID.toString])
                viewStore.send(.fetchSaveTopic(id: viewStore.card.topicID))
                viewStore.send(.addViewCount(viewStore.card))
                viewStore.send(.saveTopic(viewStore.card))
                viewStore.send(.fetchOrder)
                viewStore.send(.fetchCommentCount(viewStore.card))

                DispatchQueue.main.asyncAfter(deadline: .now() + Constant.viewCount, execute: {
                    viewStore.send(.like(viewStore.card))
                })

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    withAnimation(.spring(dampingFraction: 0.7, blendDuration: 0.9)) {
                        didLoad.toggle()
                        if notReadyAds { viewStore.send(.setToastMessage(Design.Text.notReadyAdstoast)) }
                    }
                })

                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    flipCard()
                })
            })
        }
        
    }
    
    private func bottomView(isHiddenPrevNextButton: Bool,
                            count: Int,
                            isLeftMost: Bool,
                            isRightMost: Bool,
                            didTapComment: @escaping (()->Void),
                            didTapNext: @escaping (()->Void),
                            didTapPrev: @escaping (()->Void)
    ) -> some View {
        AlignmentVStack(alignment: .bottom, spacing: 0.0) {
            HStack {
                Button {
                    didTapComment()
                } label: {
                    Image("Icon_Talk_24")
                    Text("\(count)")
                        .font(.Pretendard.b2_regular)
                        .foregroundColor(.white)
                }
                Spacer()
                if isHiddenPrevNextButton == false {
                    prevNextButtons(
                        isLeftMost: isLeftMost,
                        isRightMost: isRightMost,
                        tapPrev: {
                            didTapPrev()
                        },
                        tapNext: {
                            didTapNext()
                        })
                    .padding(.trailing, 20)
                }
            }
            .padding(.leading, 20.0)
            .frame(height: 56.0)
            .background(Color.Talkbbokki.GrayScale.gray7)
            .clipped()
            .shadow(edge: .top)
            
            Color.Talkbbokki.GrayScale.gray7
                .ignoresSafeArea()
                .frame(height: 1.0)
        }
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("Icon-arrow2_left-24")
        }
    }
    
    private var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("close")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(20)
                }
            }
            Spacer()
        }
    }
    
    private func prevNextButtons(
        isLeftMost: Bool,
        isRightMost: Bool,
        tapPrev: @escaping (()->Void),
        tapNext: @escaping (()->Void)
    ) -> some View {
        HStack(spacing: 12.0) {
            Button {
                if isLeftMost == false {
                    tapPrev()
                }
            } label: {
                HStack(spacing: 4.0) {
                    Image("Icon_refresh_18_prev")
                        .renderingMode(.template)
                        .foregroundColor(isLeftMost ? .Talkbbokki.GrayScale.gray6 : .white)
                    Text("이전 카드")
                        .font(.Pretendard.b2_bold)
                        .foregroundColor(isLeftMost ? .Talkbbokki.GrayScale.gray6 : .white)
                }
            }
            
            Divider()
                .background(Color.white)
                .frame(height: 15.0)
            
            Button {
                if isRightMost == false {
                    tapNext()
                }
            } label: {
                HStack(spacing: 4.0) {
                    Text("다음 카드")
                        .font(.Pretendard.b2_bold)
                        .foregroundColor(isRightMost ? .Talkbbokki.GrayScale.gray6 : .white)
                    Image("Icon_refresh_18_next")
                        .renderingMode(.template)
                        .foregroundColor(isRightMost ? .Talkbbokki.GrayScale.gray6 : .white)
                }
            }

        }
    }
}

// Function
extension DetailCardContainerView {
    private func dismissCard(completion: (()->Void)? = nil) {
        flipCard()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            withAnimation {
                didLoad.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                completion?()
            })
        })
    }
    
    private func presentCard(completion: (()->Void)? = nil) {
        withAnimation {
            didLoad.toggle()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            flipCard()
            isFlipping = false
            completion?()
        })
    }
    
    private func changeCard(onDismiss: @escaping (()->Void)) {
        guard isFlipping == false else { return }
        isFlipping = true
        dismissCard {
            onDismiss()
            presentCard()
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
            Model.Topic.Position.selected.background
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
    
    private var backgroundView: some View {
        Color.white
            .frame(width: Design.Constraint.cardSize.width,
                   height: Design.Constraint.cardSize.height)
    }
}

struct DetailBackCardView: View {
    let card : Model.Topic
    let order: Model.Order?
    let isSaveTopic: Bool
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
                isSaveTopic ? Image("Icon_Fill_star_24") : Image("emptyBookMark")
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
                .frame(height: 56, alignment: .topLeading)
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
        DetailCardContainerView(store: Store(initialState: DetailCardReducer.State(cards: [Model.Topic(cardNumber: 0,
                                                                                                       topicID: 1,
                                                                                                       name: "밥 먹다가 체함",
                                                                                                       viewCount: 20,
                                                                                                       createAt: "1101",
                                                                                                       category: "LOVE",
                                                                                                       pcLink: "",
                                                                                                       tag: .love)],
                                                                                   color: 0, selectedIndex: 0, card: Model.Topic(cardNumber: 0,
                                                                                                                                 topicID: 1,
                                                                                                                                 name: "밥 먹다가 체함",
                                                                                                                                 viewCount: 20,
                                                                                                                                 createAt: "1101",
                                                                                                                                 category: "LOVE",
                                                                                                                                 pcLink: "",
                                                                                                                                 tag: .love)),
                                             reducer: DetailCardReducer()),
                                color: 00,
                                notReadyAds: true,
                                isEnteredModal: true)
    }
}
