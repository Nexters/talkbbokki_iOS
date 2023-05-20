//
//  CommentView.swift
//  talkbbokki
//
//  Created by USER on 2023/05/13.
//

import SwiftUI

struct CommentView: View {
    let comment: Model.Comment
    @Binding var deleteCommentId: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            VStack(alignment: .leading, spacing: 8.0) {
                commentTitle("nickName",
                             date: comment.createdToPresent,
                             isOwner: comment.userId == Utils.getDeviceUUID()) {
                    deleteCommentId = comment._id
                }
                commentContent(comment.body)
            }
            
            commentButtons(0, isOwner: comment.userId == Utils.getDeviceUUID()) {
                
            } tapReport: {
                
            }
        }
        .padding([.top, .leading, .bottom, .trailing], 20)
    }
    
    private func commentTitle(_ title: String,
                              date: String,
                              isOwner: Bool,
                              tapClose: @escaping (()->Void)) -> some View {
        HStack(alignment: .center, spacing: 8.0) {
            Text(title)
                .foregroundColor(isOwner ? .Talkbbokki.Primary.mainColor1 : .white)
                .font(.Pretendard.b3_bold)
            Text(date)
                .foregroundColor(.Talkbbokki.GrayScale.gray6)
                .font(.Pretendard.caption1)
            Spacer()
            if isOwner {
                Button {
                    tapClose()
                } label: {
                    Image("Icon-Close-24")
                        .resizable()
                }
                .frame(width: 18,height: 18)
            }
        }
    }

    private func commentContent(_ message: String) -> some View {
        Text(message)
            .foregroundColor(.white)
            .font(.Pretendard.b3_regular)
    }
    
    private func commentButtons(_ replyCount: Int,
                                isOwner: Bool,
                                tapReply: @escaping (()->Void),
                                tapReport: @escaping (()->Void)
    ) -> some View {
        HStack(spacing: 12.0) {
            Button {
                tapReply()
            } label: {
                Text("답글 (\(replyCount))")
                    .foregroundColor(.Talkbbokki.GrayScale.gray6)
                    .font(.Pretendard.reply)
            }

            
            if isOwner { EmptyView() }
            else {
                Button {
                    tapReport()
                } label: {
                    Text("신고하기").foregroundColor(.Talkbbokki.GrayScale.gray6)
                        .font(.Pretendard.reply)
                }
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Model.Comment(_id: 0,
                                           topicId: 0,
                                           parentCommentId: nil,
                                           body: "Asdasdasdas",
                                           userId: "asdas",
                                           createAt: "2023-05-13T15:23:18Z",
                                           modifyAt: "2023-05-13T15:23:18Z"),
                    deleteCommentId: .constant(1))
        .background(Color.blue)
    }
}
