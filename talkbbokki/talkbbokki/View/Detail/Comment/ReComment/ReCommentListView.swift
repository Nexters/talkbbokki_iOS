//
//  ReCommentListView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/07/22.
//

import SwiftUI
import GoogleMobileAds

struct ReCommentListView: View {
    let parentComment: Model.Comment
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            reCommentContent()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("답글(1)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("Icon-arrow2_left-24_white")
        }
    }
    
    private func reCommentContent() -> some View {
        VStack {
            commentList()
            reCommentInput()
        }
    }
    
    private func bannerView() -> some View {
        BannerView()
            .frame(
                width: GADAdSizeBanner.size.width,
                height: GADAdSizeBanner.size.height
            )
    }
    
    private func reCommentInput() -> some View {
        VStack(spacing: .zero) {
            ReCommentDescriptionView(ownerNickName: parentComment.userNickname)
            CommentInputView(textBinding: .constant("")) {
                
            }
        }
    }
    
    private func commentList() -> some View {
        List {
            CommentView(parentType: .ReComment,
                        comment: parentComment,
                        deleteCommentId: .constant(0))
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            bannerView()
        }
        .listStyle(PlainListStyle())
    }
}

struct ReCommentListView_Previews: PreviewProvider {
    static var previews: some View {
        ReCommentListView(parentComment:
                            Model.Comment(_id: 0,
                                          topicId: 0,
                                          parentCommentId: nil,
                                          body: "Asdasdasdas",
                                          userId: "asdas",
                                          userNickname: "nickname",
                                          createAt: "2023-05-13T15:23:18Z",
                                          modifyAt: "2023-05-13T15:23:18Z")
        )
    }
}
