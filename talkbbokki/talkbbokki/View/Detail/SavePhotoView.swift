//
//  SavePhotoView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/25.
//

import SwiftUI

struct SavePhotoView: View {
    let colorHex: Int
    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
//            Color(hex: colorHex).ignoresSafeArea()
            contentView(with: "TOPIC",
                        message: "안녕하세요 ㅎㅎㅎ")
        }
    }
    
    func contentView(with title: String, message: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .font(.Pretendard.b2_regular)
                .padding([.top,.bottom], 2)
                .padding([.leading,.trailing], 8)
                .background(Color.black)
                .cornerRadius(4.0)

            Text(message)
                .foregroundColor(.white)
                .font(.Pretendard.b1_bold)
                .foregroundColor(.black)
        }
    }
}

struct SavePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SavePhotoView(colorHex: 000000)
    }
}
