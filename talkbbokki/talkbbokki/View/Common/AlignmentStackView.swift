//
//  AlignmentStackView.swift
//  talkbbokki
//
//  Created by USER on 2023/05/05.
//

import SwiftUI

enum HorizontalAlignment {
    case trailing
    case leading
}

enum VerticalAlignment {
    case top
    case bottom
}

extension View {
    @ViewBuilder
    func AlignmentHStack<Content: View>(
        with alignment: HorizontalAlignment,
        spacing: CGFloat? = nil,
        @ViewBuilder view: () -> Content) -> some View {
        switch alignment {
        case .trailing:
            HStack(spacing: spacing) {
                Spacer()
                view()
            }
        case .leading:
            HStack(spacing: spacing) {
                view()
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func AlignmentVStack<Content: View>(
        with alignment: VerticalAlignment,
        spacing: CGFloat? = nil,
        @ViewBuilder view: () -> Content
    ) -> some View {
        switch alignment {
        case .top:
            VStack(spacing: spacing) {
                view()
                Spacer()
            }
        case .bottom:
            VStack(spacing: spacing) {
                Spacer()
                view()
            }
        }
    }
}
