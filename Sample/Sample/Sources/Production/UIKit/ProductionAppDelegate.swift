//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

@UIApplicationMain
final class ProductionAppDelegate: BaseAppDelegate {

    override func makeRootViewController() -> UIViewController {
        let appServices = AppServices(
            docURL: Configuration.production.docsURL,
            githubService: GithubService(client: Configuration.production.networkClient)
            
        )
        return UIHostingController(rootView: DashboardView().environmentObject(appServices))
    }
}
