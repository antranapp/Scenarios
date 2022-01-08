//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import SwiftUI

final class GridItemViewHappyCaseScenario: Scenario {
    static var name: String = "Happy Case"
    static var kind: ScenarioKind = .component
    static var category: ScenarioCategory? = "GridItemView"
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: GridItemView(image: ImageModel.mock).frame(width: 200, height: 300))
        }
    }
}

final class GridItemViewErrorCaseScenario: Scenario {
    static var name: String = "Error Case"
    static var kind: ScenarioKind = .component
    static var category: ScenarioCategory? = "GridItemView"
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(
                rootView: GridItemView(
                    image: .failure
                )
                .frame(width: 200, height: 300)
            )
        }
    }
}
