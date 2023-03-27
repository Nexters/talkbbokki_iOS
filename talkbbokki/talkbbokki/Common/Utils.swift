//
//  Utils.swift
//  talkbbokki
//
//  Created by USER on 2023/03/11.
//

import UIKit

class Utils {
    static func getDeviceUUID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString).orEmpty
    }
}
