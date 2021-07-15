//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

class AppServices: ObservableObject {
    let docURL: URL
    let githubService: GithubService
    
    init(docURL: URL, githubService: GithubService) {
        self.docURL = docURL
        self.githubService = githubService
    }
}
