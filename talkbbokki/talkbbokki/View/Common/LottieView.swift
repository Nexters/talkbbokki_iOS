//
//  LottieView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import Foundation
import SwiftUI
import Lottie
import UIKit

// 로티 애니메이션 뷰
struct LottieView: UIViewRepresentable {
    var name : String
    var loopMode: LottieLoopMode
    
    // 간단하게 View로 JSON 파일 이름으로 애니메이션을 실행합니다.
    init(jsonName: String = "", loopMode : LottieLoopMode = .loop){
        self.name = jsonName
        self.loopMode = loopMode
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        // AspectFit으로 적절한 크기의 에니매이션을 불러옵니다.
        animationView.contentMode = .scaleAspectFit
        // 애니메이션은 기본으로 Loop합니다.
        animationView.loopMode = loopMode
        // 애니메이션을 재생합니다
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
  
  
      animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
         //레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
