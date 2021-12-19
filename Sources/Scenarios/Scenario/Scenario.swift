//
// Copyright © 2021 An Tran. All rights reserved.
//

import ObjectiveC
import UIKit

public protocol IdentifiableType: AnyObject {
    static var id: String { get }
}

public extension IdentifiableType {
    static var id: String {
        NSStringFromClass(Self.self)
    }
}

public struct ScenarioInfo {
    var name: String
    var description: String
    var configure: ((UIViewController) -> Void)?

    public init(name: String, description: String, configure: ((UIViewController) -> Void)? = nil) {
        self.name = name
        self.description = description
        self.configure = configure
    }
}

public protocol BaseScenario: IdentifiableType {
    static var name: String { get }
    static var nameForSorting: String { get }
    static var kind: ScenarioKind { get }
}

public extension BaseScenario {
    static var nameForSorting: String {
        name
    }
}

public protocol Scenario: BaseScenario {
    static var rootViewProvider: RootViewProviding { get }
    static var shortDescription: String? { get }
    static var longDescription: String? { get }
    static var category: ScenarioCategory? { get }
    static var subCategory: ScenarioCategory? { get }
    static var info: ScenarioInfo? { get }
}

public extension Scenario {
    
    static var shortDescription: String? {
        nil
    }

    static var longDescription: String? {
        nil
    }

    static var info: ScenarioInfo? {
        longDescription.map {
            ScenarioInfo(name: name, description: $0)
        }
    }
    
    static var category: ScenarioCategory? {
        nil
    }

    static var subCategory: ScenarioCategory? {
        nil
    }

}
