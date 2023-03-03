//
//  BookmarkView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/28.
//

import SwiftUI
import ComposableArchitecture

private enum Design {
    enum Constraint {
        static let topMarign: CGFloat = 24
        static let leadingMargin: CGFloat = 20.0
        static let titleAndContentSpacing: CGFloat = 36
        static let contentSpacing: CGFloat = 12
    }
    
    enum Text {
        static let title = "기억하고 싶은 대화 주제,\n여기 다 - 모아뒀어요"
        static let alertMessage = "취소하면 이 주제는 다시 보기 어려워요.\n그래도 즐겨찾기를 취소하시겠어요?"
        static let alertSubMessage = "* 이 문구는 하루에 한 번만 노출됩니다."
        static let alertConfirm = "그래도 할래요"
        static let alertDeny = "안할래요"
    }
}

struct BookmarkView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let store: StoreOf<BookmarkReducer>
    @State private var showAlert = false
    @State private var didTapAlertButton: ButtonType = .none
    @State private var didTapBookmark: Topic? = nil
    @State private var didTapDetail: Topic? = nil
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            GeometryReader { proxy in
                ZStack {
                    Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
                    ScrollView {
                        VStack(alignment: .leading, spacing: Design.Constraint.titleAndContentSpacing) {
                            title()
                            VStack(alignment: .leading, spacing: Design.Constraint.contentSpacing) {
                                countText(with: viewStore.bookmarks.count)
                                if viewStore.bookmarks.isEmpty == false {
                                    BookmarkGridView(topic: viewStore.bookmarks,
                                                     fullWidth: proxy.size.width,
                                                     didTapDetail: $didTapDetail,
                                                     didTapBookMark: $didTapBookmark)
                                }
                            }
                        }.padding([.leading, .trailing], Design.Constraint.leadingMargin)
                    }
                    
                    if viewStore.bookmarks.isEmpty {
                        emptyView
                    }
                    
                    if showAlert {
                        AlertView(message: Design.Text.alertMessage,
                                  subMessage: Design.Text.alertSubMessage,
                                  buttons: [AlertButton(type: .cancel(),
                                                        message: Design.Text.alertDeny),
                                            AlertButton(type: .confirm(), message: Design.Text.alertConfirm)
                                  ],
                                  didTapButton: $didTapAlertButton)
                    }
                }
                .onChange(of: didTapBookmark, perform: { newValue in
                    if UserDefaultValue.Onboard.showBookmarkDeleteAlert {
                        didTapAlertButton = .confirm()
                    } else {
                        UserDefaultValue.Onboard.showBookmarkDeleteAlert = true
                        showAlert.toggle()
                    }
                })
                .onChange(of: didTapAlertButton, perform: { newValue in
                    guard newValue != .none else { return }
                    if case .confirm = newValue {
                        viewStore.send(.removeBookmark(Int(didTapBookmark?.topicID ?? 0)))
                    }
                    didTapAlertButton = .none
                    if showAlert {
                        showAlert.toggle()
                    }
                })
                .fullScreenCover(item: $didTapDetail, onDismiss: {
                    viewStore.send(.fetchBookmarkList)
                },content: { detail in
                    DetailCardContainerView(store: Store(initialState: DetailCardReducer.State(),
                                                         reducer: DetailCardReducer(topic: detail.convert,
                                                                                    color: Int(detail.bgColor))),
                                            card: detail.convert,
                                            color: Int(detail.bgColor),
                                            enteredAds: false,
                                            notReadyAds: false,
                                            isEnteredModal: true)
                })
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
                .onAppear {
                    viewStore.send(.fetchBookmarkList)
                }
            }
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image("empty")
            Text("아직 즐겨찾기한 토픽이 없어요")
                .font(.Pretendard.b2_regular)
                .foregroundColor(.Talkbbokki.GrayScale.gray5)
        }
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("Icon-arrow2_left-24_white")
        }
    }
    
    private func countText(with count: Int) -> some View {
        Text("총 \(count)개")
            .font(.Pretendard.b2_regular)
            .foregroundColor(.Talkbbokki.GrayScale.gray4)
    }
    
    private func title() -> some View {
        HStack {
            Text(Design.Text.title)
                .font(.Pretendard.h2_bold)
                .foregroundColor(.white)
                .padding(.top, Design.Constraint.topMarign)
            
            Spacer()
        }
    }
}

struct BookmarkGridView: View {
    let topic: [Topic]
    let fullWidth: CGFloat
    @Binding var didTapDetail: Topic?
    @Binding var didTapBookMark: Topic?
    private let spacing = Design.Constraint.leadingMargin
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed((fullWidth/2) - spacing), spacing: 11.0),
                            GridItem(.fixed((fullWidth/2) - spacing), spacing: 11.0)
                           ]) {
            ForEach(topic) { topic in
                VStack(alignment: .leading, spacing: 8){
                    HStack {
                        bookmarkCardView(with: topic)
                        Spacer()
                        Button {
                            didTapBookMark = topic
                        } label: {
                            Image("Icon_Fill_star_24")
                        }
                    }
                    
                    Text(topic.name.orEmpty)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                        .font(.Pretendard.b3_regular)
                        .frame(minHeight: 161, alignment: .topLeading)
                }
                .padding([.top,.leading,.trailing], 16)
                .padding([.bottom], 32)
                .background(Color.white)
                .cornerRadius(8)
                .onTapGesture {
                    didTapDetail = topic
                }
            }
        }
    }
    
    private func bookmarkCardView(with topic: Topic) -> some View {
        VStack {
            Text(topic.tag.orEmpty)
                .font(.Pretendard.b1_bold)
                .foregroundColor(.black)
        }
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView(store: Store(initialState: BookmarkReducer.State(),
                                  reducer: BookmarkReducer()))
    }
}

private extension Topic {
    var convert: Model.Topic {
        var topic = Model.Topic(cardNumber: 0,
                                topicID: Int(self.topicID),
                                name: self.name.orEmpty,
                                viewCount: Int(self.viewCount),
                                createAt: self.createAt.orEmpty,
                                category: self.category.orEmpty,
                                pcLink: self.pcLink.orEmpty,
                                tag: Model.Topic.Tag(rawValue: self.tag.orEmpty) ?? .daily)
        topic.position = .selected
        return topic
    }
}
