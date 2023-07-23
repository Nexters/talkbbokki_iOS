//
//  ReCommentView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/07/22.
//

import SwiftUI

private enum ImageNamed {
    static let replyArrow = "replyArrow"
    static let close = "Icon-Close-24"
}

struct ReCommentView: View {
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            Group {
                replyContentView(
                    isOwner: false,
                    nickName: "ㅁㅁ",
                    message: "ㅇㅇㅇ",
                    date: "ㅁㅁㅁㅋ",
                    didTapClose: {
                    
                })
            }
            .padding(20)
        }
    }
    
    private func replyContentView(
        isOwner: Bool,
        nickName: String,
        message: String,
        date: String,
        didTapClose: @escaping (()->Void)
    ) -> some View {
        HStack(alignment: .top) {
            replyArrowView()
            replyMessageView(
                isOwner: isOwner,
                nickName: nickName,
                message: message,
                date: date,
                didTapClose
            )
            Spacer()
        }
    }
    
    private func replyArrowView() -> some View {
        Image(ImageNamed.replyArrow)
    }
    
    private func replyMessageView(
        isOwner: Bool,
        nickName: String,
        message: String,
        date: String,
        _ tapClose: @escaping (()->Void)
    ) -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            VStack(alignment: .leading, spacing: 8.0) {
                replyTitleView(isOwner: isOwner,
                               nickName: nickName,
                               tapClose)
                Text(message)
                    .foregroundColor(.white)
                    .font(.Pretendard.b3_regular)
            }

            Text(date)
                .foregroundColor(.Talkbbokki.GrayScale.gray6)
                .font(.Pretendard.caption1)
        }
        .background(Color.blue)
    }
    
    private func replyTitleView(
        isOwner: Bool,
        nickName: String,
        _ tapClose: @escaping (()->Void)
    ) -> some View {
        HStack {
            Text(nickName)
                .foregroundColor(isOwner ? .Talkbbokki.Primary.mainColor1 : .white)
                .font(.Pretendard.b3_bold)
            Spacer()
            replyCloseView(tapClose)
        }.background(Color.red)
    }
    
    private func replyCloseView(_ tapClose: @escaping (()->Void)) -> some View {
        Button {
            tapClose()
        } label: {
            Image(ImageNamed.close)
                .resizable()
                .frame(width: 18.0, height: 18.0)
        }
    }
}

struct ReCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ReCommentView()
    }
}
