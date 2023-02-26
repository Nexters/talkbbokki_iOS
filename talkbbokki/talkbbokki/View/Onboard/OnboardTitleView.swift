//
//  OnboardTitleView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import SwiftUI

struct OnboardTitleView: View {
    let subMessage: String
    let mainMessage: String
    let hilightedText: String
    
    var body: some View {
        VStack(alignment:.center, spacing: 8) {
            Text(subMessage)
                .foregroundColor(.Talkbbokki.GrayScale.gray4)
                .font(.Pretendard.b3_regular)
            Text.hilightedText(str: mainMessage,
                               searched: hilightedText,
                               normalColor: .Talkbbokki.GrayScale.white,
                               hilightedColor: .Talkbbokki.Primary.mainColor1,
                               hilightedFont: .Pretendard.h2_bold)
            .font(.Pretendard.h2_bold)
            .multilineTextAlignment(.center)
            .padding([.leading,.trailing], 63)
        }
    }
}

struct OnboardTitleView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardTitleView(subMessage: "안녕",
                         mainMessage: "ㅋㅋㅋㅋㅋㅋㅋㅋㅁㅁㅋㅋ",
                         hilightedText: "ㅁㅁ")
    }
}
