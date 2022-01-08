//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import SwiftUI

protocol EnvironmentScenario: Scenario {
    static var configuration: Configuration { get }
}

extension EnvironmentScenario {
    static var kind: ScenarioKind { .environment }
    
    static var shortDescription: String? {
        configuration.name
    }
    
    static var rootViewProvider: RootViewProviding {
        configuration.authenticationService.logout()
        let view = UIHostingController(rootView: DashboardView(configuration: configuration))
        return BasicAppController(rootViewController: view)
    }
}
