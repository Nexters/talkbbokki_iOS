//
//  ReCommentListView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/07/22.
//

import SwiftUI
import GoogleMobileAds
import ComposableArchitecture

struct ReCommentListView: View {
    let store: StoreOf<RecommentListReducer>
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    private let bannverView = BannerView()
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
                VStack {
                    reCommentContent(
                        viewStore.parentComment,
                        reComments: viewStore.comments,
                        inputString: viewStore.binding(get: \.inputString,
                                                       send: { .setInputString($0) }),
                        registerAction: {
                            viewStore.send(.registerRecomment(
                                message: viewStore.inputString,
                                topicId: viewStore.parentComment.topicId,
                                parentCommentId: viewStore.parentComment.id)
                            )
                        }
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationTitle("답글(\(viewStore.parentComment.childCommentCount))")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                bannverView.loadAd()
                viewStore.send(.fetchReCommentList(topicId: viewStore.parentComment.topicId,
                                                   parentId: viewStore.parentComment.id))
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
    
    private func reCommentContent(
        _ parentComment: Model.Comment,
        reComments: [Model.Comment],
        inputString: Binding<String>,
        registerAction: @escaping (()->Void)
    ) -> some View {
        VStack {
            commentList(
                parentComment: parentComment,
                reComments: reComments
            )
            reCommentInput(
                inputString,
                nickName: parentComment.userNickname,
                registerAction: registerAction
            )
        }
    }

    private func reCommentInput(
        _ inputString: Binding<String>,
        nickName: String,
        registerAction: @escaping (()->Void)
    ) -> some View {
        VStack(spacing: .zero) {
            ReCommentDescriptionView(ownerNickName: nickName)
            CommentInputView(textBinding: inputString) {
                registerAction()
            }
        }
    }

    private func commentList(
        parentComment: Model.Comment,
        reComments: [Model.Comment]
    ) -> some View {
        VStack {
            CommentView(
                parentType: .ReComment,
                comment: parentComment,
                didTapDelete: nil,
                didTapReply: nil
            )
            
            bannverView
                .frame(
                    width: GADAdSizeBanner.size.width,
                    height: GADAdSizeBanner.size.height
                )
            
            List {
                ForEach(reComments) { comment in
                    ReCommentView(comment: comment)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct ReCommentListView_Previews: PreviewProvider {
    static var previews: some View {
        ReCommentListView(store: Store(initialState: .init(parentComment: Model.Comment(_id: 0,
                                                                                        topicId: 0,
                                                                                        parentCommentId: nil,
                                                                                        childCommentCount: 0,
                                                                                        body: "Asdasdasdas",
                                                                                        userId: "asdas",
                                                                                        userNickname: "nickname",
                                                                                        createAt: "2023-05-13T15:23:18Z",
                                                                                        modifyAt: "2023-05-13T15:23:18Z"), commentsCount: 0),
                                       reducer: RecommentListReducer())
        )
    }
}
