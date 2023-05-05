//
//  AnyTransition+.swift
//  talkbbokki
//
//  Created by USER on 2023/05/03.
//

import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .trailing))}
}
