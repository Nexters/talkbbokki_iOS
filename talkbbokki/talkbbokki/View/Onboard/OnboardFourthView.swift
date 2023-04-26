//
//  OnboardFourthView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/04/27.
//

import SwiftUI

private enum Design {
    enum Text {
        static let subMessage: String = "주제에 대한 타인의 의견이 궁금하다면?"
        static let mainMessage: String = "댓글로 서로의 의견을 들어보세요!"
    }
}

struct OnboardFourthView: View {
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            VStack {
                OnboardTitleView(subMessage: Design.Text.subMessage,
                                 mainMessage: Design.Text.mainMessage,
                                 hilightedText: "댓글")
                Image("Onboarding_img_03")
            }
        }
        .ignoresSafeArea()
    }
}

struct OnboardFourthView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardFourthView()
    }
}
