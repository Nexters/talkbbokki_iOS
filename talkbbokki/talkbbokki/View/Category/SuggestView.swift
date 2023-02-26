//
//  SuggestedView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/20.
//

import SwiftUI
import Introspect
import UIKit

private enum Design {
    enum Constraint {
        static let spacing:CGFloat = 24
        static let topPadding: CGFloat = 63
        static let leadingPadding: CGFloat = 20
        static let trailingPadding: CGFloat = 20
        static let textEditHeight: CGFloat = 186
    }
    
    enum Text {
        static let mainTitle = "이런 대화 주제 왜 없어?\n직접 제안 하기"
        static let placeHolder = "재미있는 대화 주제가 떠오르셨나요?\n자유롭게 제안해주세요 :)"
    }
}

struct SuggestView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var didTapComplete: ButtonType = .none
    @State private var didTapConfirm: ButtonType = .none
    @State private var didComplete: Bool = false
    @State private var text: String = ""
    
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            VStack {
                closeButton
                Spacer()
            }
            if didComplete {
                completeAlert
                    .transition(.opacity.animation(.easeInOut))
            } else {
                suggestView
            }
        }
        .onChange(of: didTapComplete, perform: { newValue in
            presentationMode.wrappedValue.dismiss()
        })
        .onChange(of: didTapConfirm, perform: { newValue in
            let _ = API.Suggest(text: text)
                .request().sink { _ in } receiveValue: { _ in }
            didComplete.toggle()
        })
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
            UITextView.appearance().contentInset = UIEdgeInsets(top: 9.0,
                                                                left: 12.0,
                                                                bottom: 0.0,
                                                                right: 12.0)
        }
    }
    
    private var suggestView: some View {
        VStack(spacing: Design.Constraint.spacing) {
            HStack {
                Text(Design.Text.mainTitle)
                    .font(.Pretendard.h2_bold)
                    .foregroundColor(.Talkbbokki.GrayScale.white)
                Spacer()
            }
            .padding(.leading, Design.Constraint.leadingPadding)
            
            ZStack(alignment: .topLeading) {
                Group {
                    if #available(iOS 16.0, *) {
                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                    } else {
                        TextEditor(text: $text)
                    }
                }
                .introspectTextView(customize: { textView in
                    textView.becomeFirstResponder()
                })
                .overlay(placeHolder, alignment: .topLeading)
                .foregroundColor(.white)
                .background(Color.Talkbbokki.GrayScale.gray6)
                .cornerRadius(15)
                .padding([.leading,.trailing], Design.Constraint.leadingPadding)
                .frame(height: Design.Constraint.textEditHeight)
                .font(.Pretendard.b2_regular)
            }
            
            Spacer()
            ConfirmButtonView(didTapConfirm: $didTapConfirm,
                              type: .cancel(),
                              buttonMessage: "보내기")
            .padding([.leading,.trailing, .bottom], Design.Constraint.leadingPadding)
        }
        .padding(.top, Design.Constraint.topPadding)
    }
    
    private var placeHolder: some View {
        Text(text.isEmpty ? Design.Text.placeHolder : "")
            .foregroundColor(.Talkbbokki.GrayScale.gray4)
            .background(Color.clear)
            .font(.Pretendard.b2_regular)
            .padding(.top, 16)
            .padding(.leading, Design.Constraint.leadingPadding)
    }
    
    private var completeAlert: some View {
        ZStack {
            VStack(spacing: 16) {
                Image("heartImg")
                Text("소중한 의견 감사합니다 :)")
                    .font(.Pretendard.b1_bold)
                    .foregroundColor(.white)
            }
            
            VStack {
                Spacer()
                ConfirmButtonView(didTapConfirm: $didTapComplete,
                                  type: .cancel(),
                                  buttonMessage: "홈으로")
                .padding([.leading,.trailing, .bottom], Design.Constraint.leadingPadding)
            }
        }
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding([.trailing],20)
            }
        }
    }
}

struct SuggestView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestView()
    }
}
