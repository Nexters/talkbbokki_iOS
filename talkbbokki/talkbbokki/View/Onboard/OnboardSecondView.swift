//
//  OnboardSecondView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import SwiftUI

private enum Design {
    enum Text {
        static let subMessage: String = "오늘은 누구부터 이야기 해볼까요?"
        static let mainMessage: String = "톡뽀끼가 제안하는\n오늘의 STARTER!"
    }
}

struct OnboardSecondView: View {
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            VStack {
                OnboardTitleView(subMessage: Design.Text.subMessage,
                                 mainMessage: Design.Text.mainMessage,
                                 hilightedText: "STARTER!")
                LottieView(jsonName: "Onboarding_img_02_Final",
                           loopMode: .autoReverse)
                    .frame(width: 360,
                           height: 360)
            }
        }
    }
}

struct OnboardSecondView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardSecondView()
    }
}
