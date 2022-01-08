//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import SwiftUI

final class ImageViewScenario: Scenario {
    static var name: String = "ImageView"
    static var kind: ScenarioKind = .screen
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(
                rootView: ImageView(image: .mock, favouritesImageManager: MockFavouritesManager())
            )
        }
    }
}
