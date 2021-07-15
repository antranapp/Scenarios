//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class ErrorViewScenario: Scenario {
    static var name: String = "Error"
    static var kind: ScenarioKind = .component
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: ContentView())
        }
    }
}

private struct ContentView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                ErrorView(errorText: "This is a short error message")
                Text("Short")
            }
            
            Divider()
            
            ErrorView(errorText: "This is a very long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long error message")
            Text("Long, single line")
            
            Divider()
            
            ErrorView(errorText: "This is a very long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long error message", multipleLines: true)
            Text("Long, multiple lines")
        }
    }
}
