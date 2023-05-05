//
//  MenuView.swift
//  talkbbokki
//
//  Created by USER on 2023/05/03.
//

import SwiftUI

struct MenuView: View {
    let nickName: String
    @Binding var tapAction: TapAction
    private let components: [BottomComponent] = [
        .favorite,
        .suggest
    ]

    var body: some View {
        ZStack {
            Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                closeButton.padding(.leading, 15)
                topView
                bottomView.padding(.leading, 15)
            }
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 20) {
            nickNameView.padding(.leading, 19)
            Divider().background(Color.white)
        }
    }
    
    private var bottomView: some View {
        List(components) { component in
            Button {
                switch component {
                case .suggest:
                    tapAction = .suggest
                case .favorite:
                    tapAction = .favorite
                }
            } label: {
                Text(component.name)
                    .font(.Pretendard.b2_regular)
                    .foregroundColor(.Talkbbokki.GrayScale.gray4)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
    }
    
    private var closeButton: some View {
        Button {
            tapAction = .close
        } label: {
            Image("Icon-Close-24")
                .padding(.trailing, 20)
        }
    }
    
    private var nickNameView: some View {
        Button {
            tapAction = .editNickName(nickName)
        } label: {
            HStack(alignment: .center, spacing: 8.0) {
                Text(nickName)
                    .font(.Pretendard.b1_bold)
                    .foregroundColor(.white)
                Image("Icon-edit")
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(
            nickName: "돌맹이",
            tapAction: .constant(.favorite)
        )
    }
}
