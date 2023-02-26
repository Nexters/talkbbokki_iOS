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

enum ButtonType: Equatable {
    case confirm(height: CGFloat = 60)
    case ok(height: CGFloat = 60)
    case cancel(height: CGFloat = 60)
    case next(height: CGFloat = 60)
    case none
    
    var backgroundColor: Color {
        switch self {
        case .confirm: return .Talkbbokki.GrayScale.gray5
        case .cancel: return .Talkbbokki.Primary.mainColor1
        case .ok: return .Talkbbokki.GrayScale.black
        case .next: return .Talkbbokki.GrayScale.white
        case .none: return .clear
        }
    }
    
    var forgroundColor: Color {
        switch self {
        case .next: return .Talkbbokki.Primary.mainColor1
        case .confirm, .ok, .cancel, .none: return .Talkbbokki.GrayScale.white
        }
    }
    
    var height: CGFloat {
        switch self {
        case .confirm(let height): return height
        case .ok(let height): return height
        case .cancel(let height): return height
        case .next(let height): return height
        case .none: return 0.0
        }
    }
    
    func convert(with height: CGFloat) -> Self {
        switch self {
        case .confirm(_):
            return .confirm(height: height)
        case .ok(_):
            return .ok(height:height)
        case .cancel(_):
            return .cancel(height:height)
        case .next(_):
            return .next(height:height)
        case .none:
            return .none
        }
    }
}

struct ConfirmText: View {
    let type: ButtonType
    let buttonMessage: String
    var body: some View {
        Text(buttonMessage)
            .foregroundColor(type.forgroundColor)
            .fontWeight(.bold)
            .font(.system(size: 18))
            .padding(.top, 21)
            .padding(.bottom, 21)
            .frame(maxWidth: .infinity,
                   maxHeight: type.height)
            .background(type.backgroundColor)
            .cornerRadius(8)
    }
}

struct ConfirmButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButtonView(didTapConfirm: .constant(ButtonType.confirm()),
                          type: .ok(),
                          buttonMessage: "ddddd")
    }
}
