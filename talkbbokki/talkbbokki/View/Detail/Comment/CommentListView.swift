//
//  CommentView.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import SwiftUI
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
                    if viewStore.comments.isEmpty {
                        emptyView
                    } else {
                        List(viewStore.comments, id: \._id) { comment in
                            CommentView(comment: comment,
                                        deleteCommentId: viewStore.binding(get: \.deleteCommentId,
                                                                           send: { .setDeleteCommentId($0) }))
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                        }
                        .listStyle(PlainListStyle())
                    }
                    
                    inputCommentView(viewStore.binding(get: \.inputComment,
                                                       send: { .setInputComment($0) }),
                                     buttonAction: {
                        viewStore.send(.registerComment(viewStore.inputComment))
                    })
                    
                    if viewStore.showDeleteAlert {
                        showDeleteAlert(binding: viewStore.binding(get: \.tapDeleteAlert,
                                                                   send: { .setTapDeleteAlert($0) }))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationTitle("댓글(\(viewStore.commentCount))")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                    viewStore.send(.fetchComments)
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
    
    private func inputCommentView(_ binding: Binding<String>,
                                  buttonAction: @escaping (()->())
    ) -> some View {
        AlignmentVStack(with: .bottom, spacing: 0.0) {
            Group {
                ZStack(alignment: .center) {
                    CommonTextField(binding: binding,
                                    placeHolderString: "이 대화 주제 어땠나요?")
                    
                    AlignmentHStack(with: .trailing) {
                        Button {
                            buttonAction()
                        } label: {
                            Text("등록")
                                .font(.Pretendard.b2_bold)
                                .foregroundColor(.white)
                                .padding(10)
                        }
                        .padding(.trailing, 6)
                    }
                }
                .background(Color.Talkbbokki.GrayScale.gray7)
                .padding(.top, 20)
                .padding([.leading, .trailing], 16)
                .padding(.bottom, 8)
                
                Spacer().frame(height: 1.0)
            }
            .background(Color.Talkbbokki.GrayScale.gray7)
            .clipped()
            .shadow(edge: .top)
        }
    }
    
    private func showDeleteAlert(binding: Binding<ButtonType>) -> some View {
        AlertView(message: "삭제하면 이 댓글은 다시 볼 수 없어요.\n그래도 삭제하시겠어요?",
                  subMessage: "",
                  buttons: [
                    AlertButton(type: .cancel(), message: "안할래요"),
                    AlertButton(type: .ok(), message: "그래도 할래요")
                  ],
                  didTapButton: binding)
    }
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentListView(store: .init(initialState: .init(topicID: 0),
                                 reducer: CommentListReducer()))
    }
}
