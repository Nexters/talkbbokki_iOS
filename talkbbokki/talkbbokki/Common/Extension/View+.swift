//
//  View+.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import UIKit
import SwiftUI

extension View {
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
    
    
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }

    /// Layers the given views behind this ``TextEditor``.
    func textEditorBackground<V>(@ViewBuilder _ content: () -> V) -> some View where V : View {
        self
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
            .background(content())
    }
    
    static func hilightedText(str: String,
                              searched: String,
                              normalColor: Color = .black,
                              normalFont: Font = .title,
                              hilightedColor: Color,
                              hilightedFont: Font) -> Text {
        guard !str.isEmpty && !searched.isEmpty else { return Text(str) }

        var result = Text("")

        var range = str.startIndex..<str.endIndex
        repeat {
            guard let found = str.range(of: searched, options: .caseInsensitive, range: range, locale: nil) else {
                result = result + Text(str[range]).font(normalFont).foregroundColor(normalColor)
                break
            }

            let prefix = str[range.lowerBound..<found.lowerBound]
            result = result.font(normalFont).foregroundColor(normalColor) + Text(prefix).font(normalFont).foregroundColor(normalColor) + Text(str[found])
                .font(hilightedFont)
                .foregroundColor(hilightedColor)

            range = found.upperBound..<str.endIndex
        } while (true)

        return result
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    func shadow(edge: Edge.Set) -> some View {
        self
            .shadow(color: Color.black, radius: 10, x: 0, y: 0)
            .mask(Rectangle().padding(edge, -40))
    }
}
