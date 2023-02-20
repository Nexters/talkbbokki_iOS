//
//  AppDelegate.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/15.
//

import Foundation
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        config()
        return true
    }
    
    private func config() {
        FirebaseApp.configure()
        if let enterTime = UserDefaultValue.Onboard.enterTime,
           enterTime.tomorrow().compare(Date()) == .orderedAscending {
            UserDefaultValue.Onboard.didShowTopic = []
        }
        
        UserDefaultValue.Onboard.enterTime = Date()
    }
}
