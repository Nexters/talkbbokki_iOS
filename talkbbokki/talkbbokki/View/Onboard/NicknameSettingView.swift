//
//  NicknameSettingView.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture

struct NicknameSettingView: View {
    let store: StoreOf<NickNameSettingReducer>
    @Environment(\.presentationMode) private var presentationMode
    @State private var didTapConfirm: ButtonType = .none

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
                VStack(alignment: .center, spacing: 42) {
                    navigationView
                    VStack(spacing: 16) {
                        guideText
                        VStack(spacing: 8) {
                            nickNameField(textField: {
                                TextField("", text: Binding(get: { viewStore.nickName },
                                                            set: { viewStore.send(.updateTextField($0))
                                }))
                            },
                                          error: viewStore.error,
                                          nickName: viewStore.nickName)
                            errorMessage(error: viewStore.error)
                            Spacer()
                            ConfirmButtonView(didTapConfirm: $didTapConfirm,
                                              type: .cancel(),
                                              buttonMessage: "닉네임 설정하기")
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    Spacer()
                }
            }
            .onChange(of: didTapConfirm) { newValue in
                presentationMode.wrappedValue.dismiss()
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
                        presentationMode.wrappedValue.dismiss()
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
    
    
    private func nickNameField<Content: View>(@ViewBuilder textField: () -> Content,
                                              error: NickNameSettingReducer.NickNameError?,
                                              nickName: String
    ) -> some View {
        textField()
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
                    .stroke(error == nil ?
                            Color.clear : Color.red, lineWidth: 1)
            )
    }
    
    @ViewBuilder
    private func errorMessage(error: NickNameSettingReducer.NickNameError?) -> some View {
        if error == nil {
            EmptyView()
        } else {
            HStack {
                Image("Caption_red")
                Text(error?.errorMessage ?? "")
                    .font(.Pretendard.caption1)
                    .foregroundColor(Color.red)
                Spacer()
            }
        }
    }
}

struct NicknameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameSettingView(store: .init(initialState: .init(),
                                         reducer: NickNameSettingReducer()))
    }
}
