//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

@main
struct ProductionApp: App {
    var body: some Scene {
        WindowGroup {
            let appServices = AppServices(
                docURL: Configuration.production.docsURL,
                githubService: GithubService(client: Configuration.production.networkClient)
                
            )
            DashboardView().environmentObject(appServices)
        }
    }
}
