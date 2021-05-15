//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

@UIApplicationMain
class ProductionAppDelegate: BaseAppDelegate {

    override func makeRootViewController() -> UIViewController {
        return UIHostingController(rootView: HomeView())
    }
}
