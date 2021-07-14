//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct PagingHelper {
    var pageToFetch: Int = 1
    
    let maxPagesToLoad = 5
    
    // items per page returned by GitHub
    let numberOfItemsPerPage = 30
    
    mutating func updatePageToLoad(numberItemsLoaded: Int) {
        guard numberItemsLoaded > 0 else { return }
        pageToFetch += 1
    }
    
    mutating func resetPage() {
        pageToFetch = 1
    }
    
    func moreItemsToLoad(numberItemsLoaded: Int) -> Bool {
        return numberItemsLoaded >= numberOfItemsPerPage && pageToFetch <= maxPagesToLoad
    }
}
