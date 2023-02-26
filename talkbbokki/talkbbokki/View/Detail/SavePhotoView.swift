//
//  SavePhotoView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/25.
//

import SwiftUI

struct SavePhotoView: View {
    let colorHex: Int
    let contentMessage: String
    let starter: String
    var body: some View {
        ZStack {
            Color(hex: colorHex).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                contentView(with: "TOPIC", message: contentMessage, height: 196)
                    .padding([.top, .leading,.trailing],24)
                Divider()
                contentView(with: "STARTER", message: starter)
                    .padding([.leading,.trailing],24)
                    .padding(.bottom, 42)
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding([.leading,.trailing], 20)
        }
    }
    
    func contentView(with title: String, message: String, height: CGFloat = 0.0) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.white)
                .font(.Pretendard.b2_regular)
                .padding([.top,.bottom], 2)
                .padding([.leading,.trailing], 8)
                .background(Color.black)
                .cornerRadius(4.0)

            Text(message)
                .font(.Pretendard.b1_bold)
                .foregroundColor(.black)
                .frame(minHeight: height, alignment: .top)
        }
    }
}

struct SavePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SavePhotoView(colorHex: 000000,
                      contentMessage: "천사처럼 자고 있던 내 연인,슬며시 다가가 머리를 쓰다듬는데 나도 몰랐던 가발이 벗겨졌다. 모르는척 다시 씌워준다 vs 왜 날 속였냐고 따진다.",
                      starter: "번개맨")
    }
}
