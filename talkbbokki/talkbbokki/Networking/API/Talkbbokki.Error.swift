//
//  Talkbbokki.Error.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation

public struct TalkbbokkiError: ServiceErrorable {
    public let code: TalkbbokkiError.Code
    public let message: String?
    
    public static func globalException() -> Bool {
        return false
    }
}

extension TalkbbokkiError {
    public enum Code: Int, ServiceErrorCodeRawPresentable {
        case unknownError
    }
}
