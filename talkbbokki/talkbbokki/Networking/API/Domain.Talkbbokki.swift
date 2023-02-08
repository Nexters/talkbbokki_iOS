//
//  Domain.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation
import Alamofire

struct Domain { }

extension Domain {
    struct Talkbbokki: DomainConfig {
        static let domain: String = "http://api.talkbbokki.me"
        static let manager: Alamofire.Session = {
            return Alamofire.Session(configuration: .default)
        }()
        
        static var defaultHeader: [String : String]? {
            return nil
        }
        
        static var parameters: [String : Any?]? {
            return nil
        }
    }
}
