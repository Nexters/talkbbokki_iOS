//
//  UserDefault.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let container: UserDefaults
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            return container.set(newValue, forKey: key)
        }
    }

    init(key: String, defaultValue: T) {
        container = .standard
        self.key = key
        self.defaultValue = defaultValue
    }
}
