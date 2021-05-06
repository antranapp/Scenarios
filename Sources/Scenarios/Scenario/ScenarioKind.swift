//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

/// Represents a unique identifier of the set of scenarios.
public class ScenarioKind: NSObject, RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CaseIterable {
    
    /// The raw string value.
    public var rawValue: String

    /// A string representing the name of this kind.
    public var name: String { rawValue }
    
    public var nameForSorting: String {
        _nameForSorting ?? name
    }
    
    /// A textual representation of this instance.
    override public var description: String { rawValue }

    private var _nameForSorting: String?
    
    /// Creates a new kind with given raw string value.
    ///
    /// - Parameters:
    ///   - rawValue: The raw string value.
    public required init(rawValue: String) {
        self.rawValue = rawValue
        _nameForSorting = nil
    }

    /// Creates a new kind with given raw string value.
    ///
    /// - Parameters:
    ///   - value: The raw string value.
    public required convenience init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
    
    public convenience init(rawValue: String, nameForSorting: String? = nil) {
        self.init(rawValue: rawValue)
        _nameForSorting = nameForSorting
    }
    
    public static var allCases: [ScenarioKind] = {
        var count: CUnsignedInt = 0
        var cases = [ScenarioKind]()
        guard let methods = class_copyPropertyList(object_getClass(ScenarioKind.self), &count) else {
            return cases
        }
        for i in 0 ..< count {
            let selector = property_getName(methods.advanced(by: Int(i)).pointee)
            if let key = String(cString: selector, encoding: .utf8),
               let kind = ScenarioKind.value(forKey: key) as? ScenarioKind
            {
                cases.append(kind)
            }
        }
        
        return cases
    }()

}
