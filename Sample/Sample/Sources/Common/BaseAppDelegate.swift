//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

class BaseAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func makeRootViewController() -> UIViewController {
        preconditionFailure("Must be overriden by subclasses")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = makeRootViewController()
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
