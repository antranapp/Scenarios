//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import UIKit

@UIApplicationMain
final class InternalAppDelegate: BaseAppDelegate {

    // MARK: Properties

    private lazy var manager: BaseScenariosManager = {
        if #available(iOS 13, *) {
            return ScenariosManager()
        } else {
            return BaseScenariosManager()
        }
    }()

    // MARK: APIs

    override func makeRootViewController() -> UIViewController {
        manager.makeAppController().rootViewController
    }

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        defer {
            manager.prepare(window!)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @objc func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let result = manager.performAction(for: shortcutItem)
        completionHandler(result)
    }
}
