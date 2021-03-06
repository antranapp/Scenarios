//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {

    private let get: () -> Value
    private let set: (Value) -> Void

    public var wrappedValue: Value {
        get {
            get()
        }
        set {
            set(newValue)
        }
    }

    public var projectedValue: UserDefault<Value> {
        self
    }
}

public extension UserDefault {

    init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        get = { userDefaults[key: key] ?? defaultValue }
        set = { userDefaults[key: key] = $0 }
    }

}

public extension UserDefault {

    init<T>(_ key: String, userDefaults: UserDefaults = .standard) where Value == T? {
        get = { userDefaults[key: key] }
        set = { userDefaults[key: key] = $0 }
    }

}

public extension UserDefault where Value: RawRepresentable {

    init(rawValueKey key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        get = { userDefaults[rawValueKey: key] ?? defaultValue }
        set = { userDefaults[rawValueKey: key] = $0 }
    }

}

public extension UserDefault {

    init<T: RawRepresentable>(rawValueKey key: String, userDefaults: UserDefaults = .standard) where Value == T? {
        get = { userDefaults[rawValueKey: key] }
        set = { userDefaults[rawValueKey: key] = $0 }
    }

}

public extension UserDefault where Value: Codable {

    init(codableKey key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        get = { userDefaults[codableKey: key] ?? defaultValue }
        set = { userDefaults[codableKey: key] = $0 }
    }

}

public extension UserDefault {

    init<T: Codable>(codableKey key: String, userDefaults: UserDefaults = .standard) where Value == T? {
        get = { userDefaults[codableKey: key] }
        set = { userDefaults[codableKey: key] = $0 }
    }

}

private extension UserDefaults {

    subscript<Value>(key key: String) -> Value? {
        get {
            value(forKey: key) as? Value
        }
        set {
            setValue(newValue, forKey: key)
        }
    }

    subscript<Value: RawRepresentable>(rawValueKey key: String) -> Value? {
        get {
            guard let rawValue = value(forKey: key) as? Value.RawValue else { return nil }
            return Value(rawValue: rawValue)
        }
        set {
            setValue(newValue?.rawValue, forKey: key)
        }
    }

    subscript<Value: Codable>(codableKey key: String) -> Value? {
        get {
            guard let data = object(forKey: key) as? Data else { return nil }
            let jsonDecoder = JSONDecoder()
            return try? jsonDecoder.decode(Value.self, from: data)
        }
        set {
            let jsonEncoder = JSONEncoder()
            let data = try? jsonEncoder.encode(newValue)
            setValue(data, forKey: key)
        }
    }
}
