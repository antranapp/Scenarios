//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

class MockingEnvrionmentScenario: EnvironmentScenario {
    static var name: String = "Mocking"
    static var configuration: Configuration = .mocking
}

class ProductionEnvrionmentScenario: EnvironmentScenario {
    static var name: String = "Production"
    static var configuration: Configuration = .production
}

private extension Configuration {
    static let mocking = Configuration(
        docsURL: URL(string: "https://en.wikipedia.org/wiki/Scenario_(computing)")!,
        networkClient: MockNetworkClient()
    )
}
