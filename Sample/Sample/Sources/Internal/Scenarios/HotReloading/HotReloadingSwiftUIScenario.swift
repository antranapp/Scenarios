//
// Copyright © 2022 An Tran. All rights reserved.
//

import Foundation
import Inject
import Scenarios
import SwiftUI

public final class HotReloadingSwiftUIScenario: Scenario {
    public static var name: String = "SwiftUI"
    public static var kind: ScenarioKind = .prototype
    public static var category: ScenarioCategory? = "Hot Reloading"
    
    public static var rootViewProvider: RootViewProviding {
        BasicAppController(
            rootViewController: UIHostingController(rootView: ContentView())
        )
    }
}

private struct ContentView: View {
    
    @ObserveInjection var inject

    var body: some View {
        VStack {
            Text("SwiftUI: Hot Reloading is cool")
                .foregroundColor(Color.blue)
            Text("Find more at https://antran.app")
        }
        .background(Color.red)
        .enableInjection()
        .onInjection { _ in
            NotificationCenter.default.post(name: .refreshScenario, object: nil)
        }
    }
}
