//
//  CommentView.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import SwiftUI
import ComposableArchitecture

struct CommentView: View {
    let store: StoreOf<CommentReducer>
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
                if viewStore.commentCount == 0 {
                    emptyView
                }
                inputCommentView(viewStore.binding(get: \.inputComment,
                                                   send: { .setInputComment($0) }),
                                 buttonAction: {
                    viewStore.send(.registerComment(viewStore.inputComment))
                })
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationTitle("댓글(\(viewStore.commentCount))")
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
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(store: .init(initialState: .init(topicID: 0),
                                 reducer: CommentReducer()))
    }
}
