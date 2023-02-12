//
//  View+.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import SwiftUI

extension View {
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}

