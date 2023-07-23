//
//  CommentInputView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/07/22.
//

import SwiftUI

struct CommentInputView: View {
    @Binding var textBinding: String
    let registerAction: (()->Void)

    var body: some View {
        inputCommentView($textBinding,
                         registerAction: registerAction)
    }
    
    private func inputCommentView(_ textBinding: Binding<String>,
                                  registerAction: @escaping (()->())
    ) -> some View {
        VStack(spacing: 0.0) {
            Group {
                ZStack(alignment: .center) {
                    HStack {
                        CommonTextField(binding: textBinding,
                                        placeHolderString: "이 대화 주제 어땠나요?")
                        
                        Button {
                            registerAction()
                        } label: {
                            Text("등록")
                                .font(.Pretendard.b2_bold)
                                .foregroundColor(textBinding.wrappedValue.isEmpty ? .gray : .white)
                                .padding(10)
                        }
                        .disabled(textBinding.wrappedValue.isEmpty)
                        .padding(.trailing, 6)
                    }
                    .background(Color.Talkbbokki.GrayScale.gray6)
                    .cornerRadius(8)
                }
                .background(Color.Talkbbokki.GrayScale.gray7)
                .padding(.top, 20)
                .padding([.leading, .trailing], 16)
                .padding(.bottom, 8)
                
                Spacer()
                    .frame(height: 1.0)
            }
            .background(Color.Talkbbokki.GrayScale.gray7)
            .clipped()
        }
    }
}

struct CommentInputView_Previews: PreviewProvider {
    static var previews: some View {
        CommentInputView(textBinding: .constant(""), registerAction: { })
    }
}
