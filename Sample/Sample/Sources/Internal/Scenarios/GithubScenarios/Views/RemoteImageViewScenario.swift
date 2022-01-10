//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class RemoteImageViewHappyCaseDefaultSzieScenario: Scenario {
    static var name: String = "Happy Case - Default Size"
    static var kind: ScenarioKind = .component
    static var category: ScenarioCategory? = "RemoteImage"
        
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: HappyCaseDefaultSizeView())
        }
    }
}

private struct HappyCaseDefaultSizeView: View {
    let correctURL = URL(string: "https://avatars.githubusercontent.com/u/484656?v=4")!
    var body: some View {
        VStack {
            RemoteImageContainer(url: correctURL)
            Text("Happy Case - Default size")
        }
        .navigationTitle("Happy Case - Default Size")
    }
}

final class RemoteImageViewHappyCaseCustomSizeScenario: Scenario {
    static var name: String = "Happy Case - Custom Size"
    static var kind: ScenarioKind = .component
    static var category: ScenarioCategory? = "RemoteImage"

    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: HappyCaseCustomSizeView())
        }
    }
}

private struct HappyCaseCustomSizeView: View {
    let correctURL = URL(string: "https://avatars.githubusercontent.com/u/484656?v=4")!
    var body: some View {
        VStack {
            RemoteImageContainer(url: correctURL, width: 200, height: 200)
            Text("Happy Case - Size 200 x 200")
        }
        .navigationTitle("Happy Case - Custom size")
    }
}

final class RemoteImageViewErrorCaseCustomSizeScenario: Scenario {
    static var name: String = "Error Case"
    static var kind: ScenarioKind = .component
    static var category: ScenarioCategory? = "RemoteImage"

    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: UnhappyCaseView())
        }
    }
}

private struct UnhappyCaseView: View {
    let wrongURL = URL(string: "https://invalid_url.png")!
    var body: some View {
        VStack {
            RemoteImageContainer(url: wrongURL)
            Text("Error Case")
        }
        .navigationTitle("Error Case")
    }
}
