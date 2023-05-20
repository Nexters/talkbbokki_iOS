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
    case center
}

enum VerticalAlignment {
    case top
    case bottom
    case center
}

struct AlignmentHStack<Content>: View where Content: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    let view: (() -> Content)
    
    init(alignment: HorizontalAlignment, spacing: CGFloat? = nil, @ViewBuilder view: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.view = view
    }
    
    var body: some View {
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
        case .center:
            HStack(spacing: spacing) {
                Spacer()
                view()
                Spacer()
            }
        }
    }
}

struct AlignmentVStack<Content>: View where Content: View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let view: (() -> Content)
    
    init(alignment: VerticalAlignment, spacing: CGFloat? = nil, @ViewBuilder view: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.view = view
    }
    
    var body: some View {
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
        case .center:
            VStack(spacing: spacing) {
                Spacer()
                view()
                Spacer()
            }
        }
    }
}
