//
//  String+.swift
//  talkbbokki
//
//  Created by USER on 2023/02/26.
//

import Foundation

extension String {
    var isNonEmpty: Bool {
        !isEmpty
    }
    
    func validateString(_ string: String) -> Bool {
        return range(of: string, options: .regularExpression) != nil
    }
}
