//
//  OnboardFirstView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import SwiftUI
private enum Design {
    enum Text {
        static let subMessage: String = "대화 주제 고민은 그만!"
        static let mainMessage: String = "친밀도만 선택하세요!대화주제 제안해드려요"
    }
}

struct OnboardFirstView: View {
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            VStack {
                OnboardTitleView(subMessage: Design.Text.subMessage,
                                 mainMessage: Design.Text.mainMessage,
                                 hilightedText: "친밀도")
                Image("Onboarding_img_01")
            }
        }.ignoresSafeArea()
    }
}

struct OnboardFirstView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardFirstView()
    }
}
