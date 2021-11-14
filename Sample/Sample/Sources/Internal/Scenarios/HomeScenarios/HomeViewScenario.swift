//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class HomeViewScenario: Scenario {
    static var name: String = "Docs"
    static var kind: ScenarioKind = .screen
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: DocView(url: Configuration.production.docsURL))
        }
    }
}
