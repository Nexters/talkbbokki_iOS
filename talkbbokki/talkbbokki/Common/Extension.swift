//
//  Extension.swift
//  talkbbokki
//
//  Created by USER on 2023/02/11.
//

import Foundation

extension Optional {
    func unwrap(valueIfNone: Wrapped) -> Wrapped {
        return self ?? valueIfNone
    }
}

extension Optional where Wrapped: Numeric {
    var orZero: Wrapped {
        unwrap(valueIfNone: 0)
    }
}

extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    var isNotEmpty: Bool {
        isEmpty == false
    }
    
    var orEmpty: [Wrapped.Element] {
        self?.compactMap({ $0 }) ?? []
    }
}

extension Optional where Wrapped == String {
    var isEmpty: Bool {
        orEmpty.isEmpty
    }

    var isNotEmpty: Bool {
        isEmpty == false
    }

    var orEmpty: String {
        unwrap(valueIfNone: "")
    }
}
