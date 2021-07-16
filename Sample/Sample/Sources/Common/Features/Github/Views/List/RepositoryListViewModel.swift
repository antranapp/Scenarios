//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class RepositoryListViewModel: ObservableObject {
    
    private let githubService: GithubService
    private var paging = Paging()

    var searchDebounce = Debouncer<String>(0.6)
    
    @Published var repos = [Repository]()
    @Published var errorWhenLoadingRepos: Error?
    @Published var isLoading: Bool = false
         
    init(githubService: GithubService) {
        self.githubService = githubService
        
        searchDebounce.on { [weak self] query in
            self?.paging.resetPage()
            self?.fetchResults(for: query, isSearching: true)
        }
    }
    
    func fetchRepos(for query: String?) {
        guard isLoading == false else { return }

        isLoading = true
        
        guard let url = GithubURLMaker.fetchRepositoryURL(for: query, page: paging.pageToFetch) else {
            // TODO: create error object and show up info
            return
        }
        
        githubService.fetch(url: url) { [weak self] (result: Result<RepositoryList, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let listGithubRepos):
                    let listItems = listGithubRepos.listItems
                    
                    if self?.paging.pageToFetch == 1 { // first page
                        self?.repos = listItems
                    } else { // subsequent pages
                        self?.repos.append(contentsOf: listItems)
                    }
                    self?.errorWhenLoadingRepos = nil
                    self?.paging.updatePageToLoad(numberItemsLoaded: listItems.count)
                case .failure(let error):
                    self?.errorWhenLoadingRepos = error
                    print("error: \(error)")
                }
            }
        }
    }
    
    func fetchResults(for query: String?, isSearching: Bool) {
        query?.isEmpty == true ? fetchRepos(for: nil) : fetchRepos(for: query)
    }
    
    func moreItemsToLoad() -> Bool {
        return paging.moreItemsToLoad(numberItemsLoaded: repos.count)
    }
}
