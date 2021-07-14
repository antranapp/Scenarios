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
        let service = GithubService()
        let dashboardView = DashboardView().environmentObject(service)
        return BasicAppController(rootViewController: UIHostingController(rootView: dashboardView))
    }
}
