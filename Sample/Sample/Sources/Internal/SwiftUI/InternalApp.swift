//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import SwiftUI
import UIKit

@main
struct InternalApp: App {
    
    @UIApplicationDelegateAdaptor(InternalAppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            SwiftUIViewProvider(appDelegate.manager.appController)
        }
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
            case .active:
                guard let shortcutItem = appDelegate.shortcutItem else { return }
                _ = appDelegate.manager.performAction(for: shortcutItem)
            default: return
            }
        }
    }
}

final class InternalAppDelegate: NSObject, UIApplicationDelegate {
    
    fileprivate let manager = ScenariosManager()
    
    var shortcutItem: UIApplicationShortcutItem? { InternalAppDelegate.shortcutItem }
    
    fileprivate static var shortcutItem: UIApplicationShortcutItem?
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            InternalAppDelegate.shortcutItem = shortcutItem
        }
        
        let sceneConfiguration = UISceneConfiguration(
            name: "Scene Configuration",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}

private final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        InternalAppDelegate.shortcutItem = shortcutItem
        completionHandler(true)
    }
}
