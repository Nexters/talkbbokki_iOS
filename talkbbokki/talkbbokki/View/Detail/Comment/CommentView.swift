//
//  CommentView.swift
//  talkbbokki
//
//  Created by USER on 2023/05/13.
//

import SwiftUI

extension CommentView {
    enum Parent {
        case Comment
        case ReComment
    }
}

struct CommentView: View {
    let parentType: Parent
    let comment: Model.Comment
    let didTapDelete: ((Int)->Void)?
    let didTapReply: ((Model.Comment)->Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            VStack(alignment: .leading, spacing: 8.0) {
                commentTitle(comment.userNickname,
                             date: comment.createdToPresent,
                             isOwner: comment.userId == Utils.getDeviceUUID()) {
                    didTapDelete?(comment.id)
                }
                commentContent(comment.body)
            }
            
            commentButtons(
                comment.childCommentCount,
                isOwner: comment.userId == Utils.getDeviceUUID(),
                tapReply: {
                    didTapReply?(comment)
                },
                tapReport: {
                    
                }
            )
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
            if isOwner && parentType == .Comment {
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
                    Text("신고하기")
                        .foregroundColor(.Talkbbokki.GrayScale.gray6)
                        .font(.Pretendard.reply)
                }
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(
            parentType: .Comment,
            comment: Model.Comment(_id: 0,
                                   topicId: 0,
                                   parentCommentId: nil,
                                   childCommentCount: 10,
                                   body: "Asdasdasdas",
                                   userId: "asdas",
                                   userNickname: "nickname",
                                   createAt: "2023-05-13T15:23:18Z",
                                   modifyAt: "2023-05-13T15:23:18Z"),
            didTapDelete: nil,
            didTapReply: nil
        ).background(Color.blue)
    }
}
