//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class DashboardViewScenario: Scenario {
    
    static var name: String = "Dashboard"
    
    static var kind: ScenarioKind = .screen
    
    static var rootViewProvider: RootViewProviding {
        let appServices = AppServices(
            docURL: Configuration.production.docsURL,
            githubService: GithubService(client: Configuration.production.networkClient)
        )
        let dashboardView = DashboardView().environmentObject(appServices)
        return BasicAppController(rootViewController: UIHostingController(rootView: dashboardView))
    }
}
