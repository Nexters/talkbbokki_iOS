//
//  ToastView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/26.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(message)
                .padding([.top,.bottom], 5)
                .padding([.leading,.trailing], 15)
                .font(.Pretendard.button_small_regular)
                .foregroundColor(.white)
                .background(Color.black.opacity(0.6))
                .cornerRadius(4.0)
                .padding(.bottom, 20)
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "안녕하세요")
    }
}
