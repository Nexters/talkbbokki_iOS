//
//  UserDefault.Value.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import Foundation

struct UserDefaultValue { }
extension UserDefaultValue {
    
    @UserDefault(key: UserDefaultKey.didShowOnboarding, defaultValue: false)
    static var didShow: Bool
    
    @UserDefault(key: UserDefaultKey.nickName, defaultValue: "")
    static var nickName: String
    
    @UserDefault(key: UserDefaultKey.didShowTopic, defaultValue: [])
    static var didShowTopic: [Int]
    
    @OptionalUserDefault(key: UserDefaultKey.enterTime)
    static var enterTime: Date?
    
    @UserDefault(key: UserDefaultKey.viewConut, defaultValue: 1)
    static var viewCount: Int
    
    @UserDefault(key: UserDefaultKey.showBookmarkDeleteAlert, defaultValue: false)
    static var showBookmarkDeleteAlert: Bool
    
    @UserDefault(key: UserDefaultKey.pushToken, defaultValue: "")
    static var pushToken: String
    
    @StructUserDefault(key: UserDefaultKey.topics, defaultValue: [String : [Model.Topic]]())
    static var topicDict: [String : [Model.Topic]]?
}

