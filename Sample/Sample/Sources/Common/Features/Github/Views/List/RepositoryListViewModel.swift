//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class RepositoryListViewModel: ObservableObject {
    
    private let githubService: GithubService
    private var pagingHelper = PagingHelper()

    var searchDebounce = Debouncer<String>(0.6)
    
    @Published var repos = [Repository]()
    @Published var errorWhenLoadingRepos: Error?
    @Published var isLoading: Bool = false
         
    init(githubService: GithubService) {
        self.githubService = githubService
        
        searchDebounce.on { [weak self] query in
            self?.fetchResults(for: query, isSearching: true)
        }
    }
    
    func fetchRepos(for query: String?, isSearching: Bool) {
        guard isLoading == false else { return }

        isLoading = true
        
        if isSearching {
            pagingHelper.resetPage()
        }
        
        guard let urlForRequest = GithubURLs.loadReposUrl(for: query, page: pagingHelper.pageToFetch) else {
            // TODO: create error object and show up info
            return
        }
        
        githubService.fetch(url: URL(string: urlForRequest)) { [weak self] (result: Result<RepositoryList, Error>) in
            self?.isLoading = false
            switch result {
            case .success(let listGithubRepos):
                let listItems = listGithubRepos.listItems
                
                if isSearching {
                    self?.repos = listItems
                } else {
                    self?.repos.append(contentsOf: listItems)
                }
                self?.errorWhenLoadingRepos = nil
                self?.pagingHelper.updatePageToLoad(numberItemsLoaded: listItems.count)
            case .failure(let error):
                self?.errorWhenLoadingRepos = error
                print("error: \(error)")
            }
        }
    }
    
    func fetchResults(for query: String?, isSearching: Bool) {
        query?.isEmpty == true ? fetchRepos(for: nil, isSearching: isSearching) : fetchRepos(for: query, isSearching: isSearching)
    }
    
    func moreItemsToLoad() -> Bool {
        return pagingHelper.moreItemsToLoad(numberItemsLoaded: repos.count)
    }
}
