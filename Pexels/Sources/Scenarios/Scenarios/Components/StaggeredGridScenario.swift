//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import SwiftUI

final class StaggeredGridScenario: Scenario {
    static var name: String = "StaggeredGrid"
    static var kind: ScenarioKind = .component
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: ContentView())
        }
    }
}

private struct ContentView: View {
    var body: some View {
        StaggeredGrid(columns: 3, list: ImagesModel.mock.images) { image in
            GridItemView(image: image)
        }
    }
}
