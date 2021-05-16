//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

public struct Audience: RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Equatable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

public extension Audience {
    static let developer: Audience = "Developers"
}
