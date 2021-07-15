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
        longDescription
    }
    
    static var longDescription: String? {
        configuration.docsURL.absoluteString
    }
    
    static var rootViewProvider: RootViewProviding {
        let appServices = AppServices(
            docURL: configuration.docsURL,
            githubService: GithubService(client: configuration.networkClient)
        )
        let view = UIHostingController(rootView: DashboardView().environmentObject(appServices))
        return BasicAppController(rootViewController: view)
    }
}
