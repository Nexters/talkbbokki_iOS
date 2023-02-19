//
//  AlertView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/18.
//

import SwiftUI

struct AlertView: View {
    let message: String
    let confirmButton: String

    @Binding var didTapButton: Bool
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.6)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image("Crying")
                        .background(Color.red)
                    Text(message)
                }
                
                ConfirmButtonView(didTapConfirm: $didTapButton,
                                  buttonMessage: confirmButton)
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding([.leading,.trailing], 16)
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            message: "안녕",
            confirmButton: "확인",
            didTapButton: .constant(false))
    }
}
