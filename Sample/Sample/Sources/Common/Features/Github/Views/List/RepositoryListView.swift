//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import SwiftUI

struct RepositoryListView: View {

    @ObservedObject var viewModel: RepositoryListViewModel
        
    @State private var query = ""
        
    var body: some View {
        let binding = Binding<String>(
            get: { self.query },
            set: { self.query = $0; self.textFieldChanged($0) }
        )
        
        return NavigationView {
            List {
                if viewModel.errorWhenLoadingRepos != nil {
                    ErrorView(errorText: String.localizedString(forKey: "txt_error_load_repos"))
                }
                
                TextField(String.localizedString(forKey: "search_bar_hint"), text: binding, onCommit: {
                    self.viewModel.fetchResults(for: self.query, isSearching: false)
                })
                
                if viewModel.isLoading && viewModel.errorWhenLoadingRepos == nil {
                    LoadingRow(loadingText: String.localizedString(forKey: "txt_loading_repos"))
                }
                
                if viewModel.repos.count == 0 && viewModel.errorWhenLoadingRepos == nil && !viewModel.isLoading {
                    Text("txt_no_results_for_search")
                        .font(.headline)
                        .foregroundColor(Color.red)
                }
                
                ForEach(viewModel.repos, id: \.id) { repo in
                    NavigationLink(destination: RepositoryDetailView(repository: repo)) {
                        RepositoryRowView(repository: repo)
                    }
                }
                
                if viewModel.moreItemsToLoad() && viewModel.errorWhenLoadingRepos == nil {
                    LoadingRow(loadingText: String.localizedString(forKey: "txt_fetching_more")).onAppear {
                        self.viewModel.fetchResults(for: self.query, isSearching: false)
                    }
                }
            }
            .navigationBarTitle(navigationBarTitle())
            .navigationBarItems(trailing:
                NavigationLink(destination: LoginView(), label: {
                    Image(systemName: "person.crop.circle")
                        .font(Font.title.weight(.regular))
                })
            )
        }.navigationViewStyle(StackNavigationViewStyle()).onAppear {
            self.viewModel.fetchResults(for: self.query, isSearching: false)
        }
    }
    
    private func textFieldChanged(_ text: String) {
        viewModel.searchDebounce.receive(text)
    }
    
    private func navigationBarTitle() -> String {
        return query.isEmpty ? String.localizedString(forKey: "title_git_repos") : query
    }
}
