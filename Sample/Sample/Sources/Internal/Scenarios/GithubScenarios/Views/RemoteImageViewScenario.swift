//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class RemoteImageViewScenario: Scenario {
    static var name: String = "RemoteImage"
    static var kind: ScenarioKind = .component
        
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: ContentView())
        }
    }
}

private struct ContentView: View {
    
    let correctURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/736px-Google_2015_logo.svg.png")!

    let wrongURL = URL(string: "https://something.png")!

    var body: some View {
        VStack(spacing: 32) {
            VStack {
                RemoteImageContainer(url: correctURL)
                Text("Succeed: Default size")
            }
            
            Divider()

            VStack {
                RemoteImageContainer(url: correctURL, width: 200, height: 200)
                Text("Succeed: 200 x 200")
            }
            
            Divider()

            VStack {
                RemoteImageContainer(url: wrongURL)
                Text("Failed")
            }
        }
        .navigationTitle("Remote Image View")
    }
}
