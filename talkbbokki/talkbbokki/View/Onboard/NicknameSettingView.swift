//
//  NicknameSettingView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/04/27.
//

import SwiftUI

struct NicknameSettingView: View {
    enum NickNameError {
        case validString
        case overCount
        case exists
        case minimumCount
    }

    @State private var nickName: String = ""
    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            VStack(alignment: .center, spacing: 42) {
                navigationView
                
                VStack(spacing: 16) {
                    guideText
                    VStack(spacing: 8) {
                        nickNameField
                        errorMessage
                    }
                }
                .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
    
    private var navigationView: some View {
            ZStack {
                Text("닉네임 설정")
                    .foregroundColor(.white)
                    .font(.Pretendard.b2_bold)
                
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("Icon-Close-24")
                            .padding(.trailing, 20)
                    }
                }
            }.padding(.top, 18)
    }
    
    private var guideText: some View {
        HStack {
            Text("톡뽀끼에서 사용할 닉네임을 입력해 주세요!")
                .font(.Pretendard.b2_regular)
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    private var nickNameField: some View {
        TextField("", text: $nickName)
            .placeholder(when: nickName.isEmpty, placeholder: {
                Text("Enter your name")
                    .font(.Pretendard.b3_regular)
                    .foregroundColor(Color.Talkbbokki.GrayScale.gray5)
            })
            .padding(14)
            .foregroundColor(.white)
            .background(Color.Talkbbokki.GrayScale.gray6)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(nickName.isFilteringNickname() == nil ?
                            Color.clear : Color.red, lineWidth: 1)
            )
    }
    

    private var errorMessage: some View {
        HStack {
            Image("Caption_red")
            Text("ddddd")
                .font(.Pretendard.caption1)
                .foregroundColor(Color.red)
            Spacer()
        }
    }
}

private extension String {
    func isFilteringNickname() -> NicknameSettingView.NickNameError? {
        let filterString = "!@#$%^&*()_+=-,./<>?`~"
        if contains(filterString) {
            return .validString
        }

        if self.count >= 10 {
            return .overCount
        }

        if self.count < 2 && self.count >= 1 {
            return .minimumCount
        }

        return nil
    }
}

struct NicknameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameSettingView()
    }
}
