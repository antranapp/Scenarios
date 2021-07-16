//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

enum GithubURLMaker {
        
    static func fetchRepositoryURL(for query: String?, page: Int) -> URL? {
        guard let queryString = query else {
            return URL(string: "https://api.github.com/search/repositories?q=language:swift+sort:stars&page=\(page)")
        }
        
        guard let urlQuery = queryString.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("error when creating query string")
            return nil
        }
        
        return URL(string: "https://api.github.com/search/repositories?q=\(urlQuery)+sort:stars&page=\(page)")
    }
    
}
