//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios

extension ScenarioKind {
    @objc static let environment = ScenarioKind(rawValue: "Environment", nameForSorting: "1")
    @objc static let screen = ScenarioKind(rawValue: "Screen", nameForSorting: "2")
    @objc static let component = ScenarioKind(rawValue: "Component", nameForSorting: "3")
    @objc static let designSystem = ScenarioKind(rawValue: "Design System", nameForSorting: "3")
    @objc static let networking = ScenarioKind(rawValue: "Networking", nameForSorting: "4")
}
