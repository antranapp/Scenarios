//
//  HomeViewScenario.swift
//  Sample-Internal
//
//  Created by An Tran on 16/5/21.
//

import Foundation
import Scenarios
import SwiftUI

final class HomeViewScenario: Scenario {
    static var name: String = "Home"
    static var kind: ScenarioKind = .screen
    static var rootViewProvider: RootViewProviding {
        BasicAppController(rootViewController: UIHostingController(rootView: HomeView(message: "Hello World from Scenarios")))
    }
}


public extension ScenarioKind {
    @objc static let screen: ScenarioKind = "Screen"
}
