//
//  Array+.swift
//  talkbbokki
//
//  Created by USER on 2023/02/12.
//

import Foundation

extension Array {
    internal func validate(index: Index) -> Index? {
        if self.startIndex <= index && index < self.endIndex {
            return index
        }

        return nil
    }

    public subscript(safe index: Index?) -> Element? {
        return index.flatMap(self.validate)
                    .map { self[$0] }
    }
}
