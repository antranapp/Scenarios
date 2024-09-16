//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import ObjectiveC
import SwiftUI

public struct ScenarioId: CaseIterable, Hashable, Identifiable, RawRepresentable, Codable {

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
        Array(_allCases)
    }()

    public static let _allCases: some Sequence<ScenarioId> = {
//    public static let allCases: [ScenarioId] = {
//        var count: UInt32 = 0
//        let classes = objc_copyClassList(&count)
//        let buffer = UnsafeBufferPointer(start: classes, count: Int(count))
//        return Array(
//            (0 ..< Int(count))
//                .lazy
//                .compactMap { buffer[$0] as? Scenario.Type }
//                .map { ScenarioId(withType: $0) }
//        )
//        .sorted { $0.scenarioType.name < $1.scenarioType.name }
        // AnyClass.init seems to register new objective-C class the first time it is called.
        //
        // In order for the count variable to reserve enough capacity, we call this method once
        // so that any new classes are registered to the runtime.
        _ = [AnyClass](unsafeUninitializedCapacity: Int(1)) { buffer, initialisedCount in
            initialisedCount = 0
        }

        // Improved thanks to some hints from https://stackoverflow.com/a/54150007
        let count = objc_getClassList(nil, 0)
        let classes = [AnyClass](unsafeUninitializedCapacity: Int(count)) { buffer, initialisedCount in
            let autoreleasingPointer = AutoreleasingUnsafeMutablePointer<AnyClass>(buffer.baseAddress)
            initialisedCount = Int(objc_getClassList(autoreleasingPointer, count))
        }
        
        return classes
            .lazy
            // The `filter` is necessary. Without it we may crash.
            //
            // The cast using `as?` calls some objective-c methods on the type to check for conformance. But certain
            // system types do not implement that method and would cause a crash (possible bug in the runtime?).
            //
            // `class_conformsToProtocol` is safe to call on all types, so we use it to filter down to “our” classes
            // we try to cast them.
            .filter { class_inherited_conformsToProtocol($0, ScenarioMarker.self) }
            .compactMap { $0 as? Scenario.Type }
            .map { ScenarioId(withType: $0) }
    }()
}

private func class_inherited_conformsToProtocol(_ cls: AnyClass, _ p: Protocol) -> Bool {
    if class_conformsToProtocol(cls, p) { return true }
    guard let sup = class_getSuperclass(cls) else { return false }
    return class_inherited_conformsToProtocol(sup, p)
}

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
