//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import ObjectiveC
import SwiftUI

public struct ScenarioId: CaseIterable, Hashable, Identifiable, RawRepresentable {

    public var scenarioType: Scenario.Type

    init(withType type: Scenario.Type) {
        scenarioType = type
    }

    public init?(rawValue: String) {
        guard
            let type = NSClassFromString(rawValue),
            let conformingType = type as? Scenario.Type
        else {
            return nil
        }
        scenarioType = conformingType
    }

    public var rawValue: String {
        NSStringFromClass(scenarioType)
    }

    public var id: ScenarioId { self }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(scenarioType.id)
    }

    public static func == (lhs: ScenarioId, rhs: ScenarioId) -> Bool {
        lhs.scenarioType.id == rhs.scenarioType.id
    }

    public static let allCases: [ScenarioId] = {
        var count: UInt32 = 0
        let classes = objc_copyClassList(&count)
        let buffer = UnsafeBufferPointer(start: classes, count: Int(count))
        return Array(
            (0 ..< Int(count))
                .lazy
                .compactMap { buffer[$0] as? Scenario.Type }
                .map { ScenarioId(withType: $0) }
        )
        .sorted { $0.scenarioType.name < $1.scenarioType.name }
    }()

}

// TODO: Change to struct and use ExpressibleByStringLiteral
public protocol ScenarioCategory {
    var id: String { get }
    var name: String { get }
}

extension String: ScenarioCategory {
    public var id: String {
        self
    }
    
    public var name: String {
        self
    }
}
