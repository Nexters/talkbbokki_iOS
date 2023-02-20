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

@propertyWrapper
struct OptionalUserDefault<T> {
    let container: UserDefaults
    let key: String

    var wrappedValue: T? {
        get {
            container.object(forKey: key) as? T
        }
        set {
            if newValue == nil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
        }
    }

    init(key: String) {
        container = .standard
        self.key = key
    }
}

@propertyWrapper
struct StructUserDefault<T: Codable> {
    private let container: UserDefaults
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        container = .standard
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            if let savedData = container.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        set {
            if newValue == nil {
                container.removeObject(forKey: key)
                return
            }
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                container.setValue(encoded, forKey: key)
            }
        }
    }
}
