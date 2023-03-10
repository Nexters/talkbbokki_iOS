//
//  AppDelegate.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/15.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseMessaging
import GoogleMobileAds

//test 광고 ID: ca-app-pub-3940256099942544/4411468910
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        config()
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("AppDelegate - continue userActivity")
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL else { return false }
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamiclink, error) in }
        return handled
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            return true
          }
          return false
    }
    
    private func config() {
        FirebaseApp.configure()
        if let enterTime = UserDefaultValue.Onboard.enterTime,
           enterTime.tomorrow().compare(Date()) == .orderedAscending {
            resetUserDefault()
        }
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["2e06d1a3f43bc13577740048b1c7d24f",
                                                                                    GADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UserDefaultValue.Onboard.enterTime = Date()
        UIApplication.shared.statusBarStyle = .lightContent
        
        registerNotification()
        registerToken()
    }
    
    private func resetUserDefault() {
        UserDefaultValue.Onboard.didShowTopic = []
        UserDefaultValue.Onboard.viewCount = 1
        UserDefaultValue.Onboard.showBookmarkDeleteAlert = false
    }
    
    private func registerNotification() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
    }
    
    private func registerToken() {
        Messaging.messaging().delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken: \(fcmToken)")
    }
}
