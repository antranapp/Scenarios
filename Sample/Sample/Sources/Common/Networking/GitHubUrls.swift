//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

enum GithubURLs {
        
    static func loadReposUrl(for query: String?, page: Int) -> String? {
        guard let queryString = query else {
            return "https://api.github.com/search/repositories?q=language:swift+sort:stars&page=\(page)"
        }
        
        guard let urlQuery = queryString.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("error when creating query string")
            return nil
        }
        
        return "https://api.github.com/search/repositories?q=\(urlQuery)+sort:stars&page=\(page)"
    }
    
}
