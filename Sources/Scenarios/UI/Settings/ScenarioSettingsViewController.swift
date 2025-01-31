//
//  File.swift
//  
//
//  Created by Tran Binh An on 31/1/25.
//

import Foundation
import SwiftUI
import UIKit

struct ScenarioSettingsView: View {
    @AppStorage("Scenarios.storeLastSelectedScenario") private var storeLastSelectedScenario: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $storeLastSelectedScenario) {
                    Text("Persist the selected Scenario")
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
        }
    }
}

class ScenarioSettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scenarioSettingsView = ScenarioSettingsView()
        let hostingController = UIHostingController(rootView: scenarioSettingsView)
        
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
