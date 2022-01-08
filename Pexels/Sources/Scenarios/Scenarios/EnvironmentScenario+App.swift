//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

final class MockingEnvrionmentScenario: EnvironmentScenario {
    static var name: String = "Mocking"
    static var configuration: Configuration = .mocking
}

final class ProductionEnvrionmentScenario: EnvironmentScenario {
    static var name: String = "Production"
    static var configuration: Configuration = .production
}
