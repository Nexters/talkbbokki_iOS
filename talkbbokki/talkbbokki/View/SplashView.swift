//
//  SplashView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            LottieView(jsonName: "Splash_Final_ios",
                       loopMode: .playOnce)
            Image("Logo_Width").offset(y: 80)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
