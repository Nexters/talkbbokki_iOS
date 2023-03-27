//
//  Log.Firebase.swift
//  talkbbokki
//
//  Created by USER on 2023/03/27.
//

import Foundation
import FirebaseAnalytics

extension Log.Firebase {
    enum Key: String {
        case app_launch_from_push
        case app_launch_from_link
        case app_launch
        case click_category_level1
        case click_category_level2
        case click_category_level3
        case click_category_event
        case click_bookmark_menu
        case screen_card_detail
        case click_card_download
        case click_card_share
        case click_card_bookmark
    }
    
    static func sendLog(key: Key, parameters: [String: String]? = nil) {
        Analytics.logEvent(key.rawValue, parameters: parameters)
    }
    
    static func registerLog() {
        Analytics.setUserID(Utils.getDeviceUUID())
    }
    
    static func sendCategory(level: Model.Category.Level, text: String) {
        switch level {
        case .level1:
            sendLog(key: .click_category_level1, parameters: ["category_title": text])
        case .level2:
            sendLog(key: .click_category_level2, parameters: ["category_title": text])
        case .level3:
            sendLog(key: .click_category_level3, parameters: ["category_title": text])
        case .event:
            sendLog(key: .click_category_event, parameters: ["category_title": text])
        default:
            sendLog(key: .click_category_event, parameters: ["category_title": text])
        }
    }
}
