//
//  ReCommentDescriptionView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/07/22.
//

import SwiftUI

struct ReCommentDescriptionView: View {
    let ownerNickName: String
    var body: some View {
        HStack(spacing: 2.0) {
            Text(ownerNickName)
                .foregroundColor(.white)
                .font(.Pretendard.b3_bold)
            Text("님에게 답글 남기는 중")
                .foregroundColor(.white)
                .font(.Pretendard.b3_regular)
            Spacer()
        }
        .padding([.trailing, .leading], 20)
        .padding([.top, .bottom], 8)
        .background(Color.Talkbbokki.GrayScale.gray65)
    }
}

struct ReCommentDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ReCommentDescriptionView(ownerNickName: "가브리엘")
    }
}
