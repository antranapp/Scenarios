//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var appServices: AppServices
    
    var body: some View {
        TabView {
            RepositoryListView(viewModel: RepositoryListViewModel(githubService: appServices.githubService))
                .tabItem {
                    Label("Github", systemImage: "folder.circle")
                }

            DocView(url: appServices.docURL)
                .tabItem {
                    Label("Docs", systemImage: "book.circle")
                }
        }
    }
}
