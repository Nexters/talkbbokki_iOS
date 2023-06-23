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
    
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
    
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}

extension String: Identifiable {
    public var id: Self { self }
}
