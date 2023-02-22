//
//  UserDefault.Value.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import Foundation

struct UserDefaultValue { }
extension UserDefaultValue {
    enum Onboard {
        @UserDefault(key: UserDefaultKey.didShowOnboarding, defaultValue: false)
        static var didShow: Bool
        
        @UserDefault(key: UserDefaultKey.didShowTopic, defaultValue: [])
        static var didShowTopic: [Int]
        
        @OptionalUserDefault(key: UserDefaultKey.enterTime)
        static var enterTime: Date?
        
        @UserDefault(key: UserDefaultKey.viewConut, defaultValue: 0)
        static var viewCount: Int
    }
}

