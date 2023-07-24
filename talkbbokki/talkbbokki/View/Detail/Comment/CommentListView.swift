//
//  CommentView.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import SwiftUI
import GoogleMobileAds
import ComposableArchitecture

struct CommentListView: View {
    let store: StoreOf<CommentListReducer>
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
                if viewStore.didLoad == false {
                    ActivityIndicator()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                } else {
                    VStack {
                        BannerView()
                            .frame(
                                width: GADAdSizeBanner.size.width,
                                height: GADAdSizeBanner.size.height
                            )

                        if viewStore.comments.isEmpty {
                            Spacer()
                            emptyView
                        }
                        
                        if viewStore.comments.count > 0 {
                            commentList(
                                viewStore.comments,
                                nextId: viewStore.nextPage,
                                didScrollToBottom: {
                                    viewStore.send(.fetchComments(next: viewStore.nextPage))
                                },
                                didTapDelete: { deleteId in
                                    viewStore.send(.setDeleteCommentId(deleteId))
                                },
                                didTapReply: { comment in
                                    viewStore.send(.setReCommentList(comment))
                                }
                            )
                        } else {
                            Spacer()
                        }
                        
                        CommentInputView(textBinding: viewStore.binding(get: \.inputComment,
                                                                        send: { .setInputComment($0) })) {
                            viewStore.send(.registerComment(viewStore.inputComment))
                        }
                                                                        .shadow(edge: .top)
                    }
                    
                    if viewStore.showDeleteAlert {
                        showDeleteAlert(binding: viewStore.binding(get: \.tapDeleteAlert,
                                                                   send: { .setTapDeleteAlert($0) }))
                    }
                }
                
                NavigationLink(isActive: viewStore.binding(get: \.showReCommentList,
                                                           send: { .setShowReCommentList($0) })) {
                    IfLetStore(self.store.scope(state: \.reCommentState,
                                                action: { .reCommentDelegate($0)
                    })) {
                        ReCommentListView(store: $0)
                    }
                } label: {}
                    .navigationBar(titleColor: Color.Talkbbokki.GrayScale.white,
                                   font: .Pretendard.b2_bold)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationTitle("댓글(\(viewStore.commentCount))")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                    viewStore.send(.fetchComments(next: nil))
                })
            }
        }
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("Icon-arrow2_left-24_white")
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image("empty")
            Text("아직 등록된 댓글이 없어요\n첫 번째 댓글을 달아보세요")
                .font(.Pretendard.b2_regular)
                .foregroundColor(.Talkbbokki.GrayScale.gray5)
        }
    }
    
    private func commentList(
        _ comments: [Model.Comment],
        nextId: Int?,
        didScrollToBottom: @escaping (()->()),
        didTapDelete: @escaping ((Int)->Void),
        didTapReply: @escaping ((Model.Comment)->Void)
    ) -> some View {
        List {
            ForEach(comments) { comment in
                CommentView(
                    parentType: .Comment,
                    comment: comment,
                    didTapDelete: { deleteId in
                        didTapDelete(deleteId)
                    },
                    didTapReply: { comment in
                        didTapReply(comment)
                    }
                )
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            
            if nextId.isNonEmpty {
                AlignmentHStack(alignment: .center) {
                    ActivityIndicator()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .onAppear {
                    didScrollToBottom()
                    print("did bottom")
                }
            }
        }.listStyle(PlainListStyle())
    }
    
    private func showDeleteAlert(binding: Binding<ButtonType>) -> some View {
        AlertView(message: "삭제하면 이 댓글은 다시 볼 수 없어요.\n그래도 삭제하시겠어요?",
                  subMessage: "",
                  buttons: [
                    AlertButton(type: .cancel(), message: "안할래요"),
                    AlertButton(type: .ok(), message: "그래도 할래요")
                  ],
                  didTapButton: binding,
                  isShowImage: false
        )
    }
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentListView(store: .init(initialState: .init(topicID: 0),
                                 reducer: CommentListReducer()))
    }
}
