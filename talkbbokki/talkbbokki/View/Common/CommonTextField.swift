//
//  CommonTextField.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import SwiftUI

struct CommonTextField: View {
    let binding: Binding<String>
    let placeHolderString: String

    var body: some View {
        TextField("", text: binding)
            .placeholder(when: binding.wrappedValue.isEmpty) {
                Text(placeHolderString)
                    .font(.Pretendard.b3_regular)
                    .foregroundColor(Color.Talkbbokki.GrayScale.gray5)
            }
            .padding(14)
            .foregroundColor(.white)
    }
}

struct CommonTextField_Previews: PreviewProvider {
    static var previews: some View {
        CommonTextField(binding: .constant("ss"),
                        placeHolderString: "dddd")
    }
}


