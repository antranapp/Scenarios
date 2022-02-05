//
//  File.swift
//  
//
//  Created by An Tran on 6/2/22.
//

import Foundation
import UIKit
import SwiftUI

@available(iOS 14.0, *)
final class ScenarioSelectorSplitAppController: BaseSectionManager, RootViewProviding {
    
    let rootViewController: UIViewController
    
    private var splitViewController: UISplitViewController? {
        rootViewController as? UISplitViewController
    }
        
    override init(
        targetAudience: Audience?,
        select: @escaping (ScenarioId) -> Void
    ) {
        let splitViewController = UISplitViewController(style: .doubleColumn)
        rootViewController = splitViewController
        
        super.init(targetAudience: targetAudience, select: select)
        
        let scenariosViewController = makeScenarioViewController(with: sections)
        splitViewController.setViewController(scenariosViewController, for: .primary)
        
        setScenario(nil)
    }
    
    func setScenario(_ id: ScenarioId?) {
        if let id = id {
            splitViewController?.setViewController(id.scenarioType.rootViewProvider.rootViewController, for: .secondary)
        } else {
            splitViewController?.setViewController(UIHostingController(rootView: ContentView(title: "Choose an scenario form the menu")), for: .secondary)
        }
    }
}

@available(iOS 14.0, *)
private struct ContentView: View {
    let title: String
    
    var body: some View {
        Text(title)
    }
}
