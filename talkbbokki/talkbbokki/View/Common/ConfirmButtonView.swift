//
//  ConfirmButtonView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import SwiftUI

struct ConfirmButtonView: View {
    @Binding var didTapConfirm: Bool
    let buttonMessage: String
    var body: some View {
        Button {
            didTapConfirm.toggle()
        } label: {
            ConfirmText(buttonMessage: buttonMessage)
        }
    }
}

struct ConfirmText: View {
    let buttonMessage: String
    var body: some View {
        Text(buttonMessage)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(.system(size: 18))
            .padding(.top, 21)
            .padding(.bottom, 21)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(8)
            .padding(.leading, 20)
            .padding(.trailing, 20)
    }
}

struct ConfirmButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButtonView(didTapConfirm: .constant(true),
                          buttonMessage: "ddddd")
    }
}
