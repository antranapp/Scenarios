//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class LoadingViewScenario: Scenario {
    static var name: String = "Loading"
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
                LoadingView(isLoading: true, activityIndicatorStyle: .large)
                Text("loading: true, style: large")
            }
            
            Divider()
            
            VStack {
                LoadingView(isLoading: true, activityIndicatorStyle: .medium)
                Text("loading: true, style: medium")
            }
            
            Divider()
            
            VStack {
                LoadingView(isLoading: false, activityIndicatorStyle: .medium)
                Text("loading: false, style: medium")
            }
        }
    }
}
