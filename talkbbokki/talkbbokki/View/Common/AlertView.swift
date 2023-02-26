//
//  AlertView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/18.
//

import SwiftUI

struct AlertView: View {
    let message: String
    let subMessage: String
    let buttons: [AlertButton]

    @Binding var didTapButton: ButtonType
    @State private var didAppear: Bool = false
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.0
    var body: some View {
        ZStack {
            Color.black
                .opacity(opacity)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Group {
                    VStack(alignment: .center,spacing: 16) {
                        Image("Crying")
                        VStack(spacing: 4) {
                            Text(message).multilineTextAlignment(.center)
                                .font(.Pretendard.b2_bold)
                                .foregroundColor(.Talkbbokki.GrayScale.black)
                            if subMessage.isEmpty == false {
                                Text(subMessage)
                                    .multilineTextAlignment(.center)
                                    .font(.Pretendard.caption1)
                                    .foregroundColor(.Talkbbokki.GrayScale.gray4)
                            }
                        }
                    }
                    .padding(.top, 24)
                    
                    HStack {
                        ForEach(buttons) { button in
                            ConfirmButtonView(didTapConfirm: $didTapButton,
                                              type: button.type.convert(with: 50),
                                              buttonMessage: button.message)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .padding([.leading, .trailing], 16)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding([.leading,.trailing], 28)
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

struct AlertButton: Identifiable {
    var id: CGFloat {
        Date().timeIntervalSince1970
    }
    let type: ButtonType
    let message: String
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            message: "안녕\naa",
            subMessage: "ㅋㅋㅋzzadasdadaaasdasd",
            buttons: [AlertButton(type: .ok(), message: "확인"),
                      AlertButton(type: .cancel(), message: "취소")],
            didTapButton: .constant(.confirm()))
    }
}
