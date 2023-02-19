//
//  ConfirmButtonView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import SwiftUI

struct ConfirmButtonView: View {
    @Binding var didTapConfirm: ButtonType
    let type: ButtonType
    let buttonMessage: String
    var body: some View {
        Button {
            didTapConfirm = type
        } label: {
            ConfirmText(type: type,
                        buttonMessage: buttonMessage)
        }
    }
}

enum ButtonType {
    case confirm
    case ok
    case cancel
    case none
    
    var backgroundColor: Color {
        switch self {
        case .confirm: return .Talkbbokki.GrayScale.gray5
        case .cancel: return .Talkbbokki.Primary.mainColor1
        case .ok: return .Talkbbokki.GrayScale.black
        case .none: return .clear
        }
    }
}

struct ConfirmText: View {
    let type: ButtonType
    let buttonMessage: String
    var body: some View {
        Text(buttonMessage)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(.system(size: 18))
            .padding(.top, 21)
            .padding(.bottom, 21)
            .frame(maxWidth: .infinity)
            .background(type.backgroundColor)
            .cornerRadius(8)
    }
}

struct ConfirmButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButtonView(didTapConfirm: .constant(ButtonType.confirm),
                          type: .ok,
                          buttonMessage: "ddddd")
    }
}
