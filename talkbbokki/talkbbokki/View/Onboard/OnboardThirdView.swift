//
//  OnboardThirdView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import SwiftUI

private enum Design {
    enum Text {
        static let subMessage: String = "온라인이든, 오프라인이든 상관없어요!"
        static let mainMessage: String = "뽑은 대화주제\n손쉽게 공유하세요!"
    }
}

struct OnboardThirdView: View {
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            VStack {
                OnboardTitleView(subMessage: Design.Text.subMessage,
                                 mainMessage: Design.Text.mainMessage,
                                 hilightedText: "공유")
                Image("Onboarding_img_03")
            }
        }
    }
}

struct OnboardThirdView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardThirdView()
    }
}
