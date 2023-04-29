//
//  AppDelegate.swift
//  talkbbokki
//
//  Created by haehyeon.jeong on 2023/02/15.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAnalytics
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseMessaging
import GoogleMobileAds

//test 광고 ID: ca-app-pub-3940256099942544/4411468910
class AppDelegate: NSObject, UIApplicationDelegate {
    private var bag = Set<AnyCancellable>()
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
            Log.Firebase.sendLog(key: .app_launch_from_link)
            return true
          }
          return false
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        
        // Print full message.
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        return UIBackgroundFetchResult.newData
    }
    
    private func config() {
        FirebaseApp.configure()
        if let enterTime = UserDefaultValue.enterTime,
           enterTime.tomorrow().compare(Date()) == .orderedAscending {
            resetUserDefault()
        }
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["2e06d1a3f43bc13577740048b1c7d24f",
                                                                                    GADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UserDefaultValue.enterTime = Date()
        UIApplication.shared.statusBarStyle = .lightContent
        
        registerNotification()
        registerToken()

        Log.Firebase.registerLog()
        Log.Firebase.sendLog(key: .app_launch)
    }
    
    private func resetUserDefault() {
        UserDefaultValue.didShowTopic = []
        UserDefaultValue.viewCount = 1
        UserDefaultValue.showBookmarkDeleteAlert = false
        UserDefaultValue.topicDict = [String: [Model.Topic]]()
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
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)

            // ...

            // Print full message.
            print(userInfo)

            // Change this to your preferred presentation option
            return [[.alert, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]
        let title = alert?["title"]
        
        Log.Firebase.sendLog(key: .app_launch_from_push, parameters: ["noti_info": title ?? ""])
        print(userInfo)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        if UserDefaultValue.pushToken != fcmToken.orEmpty {
//            postToken(token: fcmToken.orEmpty)
            UserDefaultValue.pushToken = fcmToken.orEmpty
        }
    }
}
