//
//  EmoticonAlert.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import SwiftUI

struct EmoticonAlert: View {
    let imageName: String
    let message: String
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.0
    @State private var didAppear: Bool = false
    var body: some View {
        ZStack {
            Color.Talkbbokki.GrayScale.black.opacity(opacity).ignoresSafeArea()
            VStack(spacing: 16) {
                Image(imageName)
                Text(message)
                    .foregroundColor(.Talkbbokki.GrayScale.white)
                    .font(.Pretendard.b1_bold)
            }
            .scaleEffect(scale)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: didAppear)
        .onAppear {
            didAppear.toggle()
            opacity = 0.6
            scale = 1.0
        }
    }
}

struct EmoticonAlert_Previews: PreviewProvider {
    static var previews: some View {
        EmoticonAlert(imageName: "heartImg",
                      message: "알라븅")
    }
}
