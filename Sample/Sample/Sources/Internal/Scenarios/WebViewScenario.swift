//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class WebViewHardCodeTitleScenario: Scenario {
    static var name: String = "Hard-coded title"
    static var kind: ScenarioKind = .component
    static var category: ScenarioCategory? = "WebView"
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: NavigableWebView(title: "WebView", url: URL(string: "https://www.google.com")!))
        }
    }
}

final class WebViewHardDynamicTitleScenario: Scenario {
    static var name: String = "Dynamic title"
    static var kind: ScenarioKind = .component
    static var category: ScenarioCategory? = "WebView"
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: NavigableWebView(url: URL(string: "https://www.google.com")!))
        }
    }
}
