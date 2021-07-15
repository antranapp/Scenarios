//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var githubService: GithubService
    
    var body: some View {
        TabView {
            RepositoryListView(viewModel: RepositoryListViewModel(githubService: githubService))
                .tabItem {
                    Label("Github", systemImage: "folder.circle")
                }

            DocView()
                .tabItem {
                    Label("Docs", systemImage: "book.circle")
                }
        }
    }
}
