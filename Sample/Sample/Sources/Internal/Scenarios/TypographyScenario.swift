//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

public class TypographyScenario: AudienceTargetableScenario {
    public static let name = "Typography"
    public static let kind = ScenarioKind.designSystem
    
    public static var rootViewProvider: RootViewProviding {
        UserInterfaceToogleableNavigationAppController(withResetButton: true) { _ in
            ReloadableHostingViewController(rootView: ContentView())
        }
    }
}

private struct ContentView: View, Reloadable {
    
    @State var count: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("This is large title")
                    .font(.largeTitle)
                Text("This is title")
                    .font(.title)
                Text("This is title2")
                    .font(.title2)
                Text("This is title3")
                    .font(.title3)
                Text("This is headline")
                    .font(.headline)
            }
            
            Group {
                Text("This is body")
                    .font(.body)
                Text("This is callout")
                    .font(.callout)
                Text("This is footnote")
                    .font(.footnote)
                Text("This is caption")
                    .font(.caption)
                Text("This is caption2")
                    .font(.caption2)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Dark/Light Mode")
    }
    
    func reload() {
        count += 1
    }
}
