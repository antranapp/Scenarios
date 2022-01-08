//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import SwiftUI

final class FavouritesViewScenario: Scenario {
    static var name: String = "FavourtiesView"
    static var kind: ScenarioKind = .screen
    
    static var rootViewProvider: RootViewProviding {
        return BasicAppController(
            rootViewController: UIHostingController(
                rootView: FavouritesView(service: MockFavouritesManager())
            )
        )
    }
}
