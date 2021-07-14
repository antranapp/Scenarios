//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct Repository: Codable {
    var id: Double
    let repoName: String
    
    let owner: Owner?
    let numberOfForks: Int?
    let numberOfWatchers: Int?
    let repoDescription: String?
    let forksUrl: URL?
    let htmlUrl: URL
    let license: License?
        
    // use CodingKeys to not depend on the naming of the api
    private enum CodingKeys: String, CodingKey {
        case id
        case owner
        case repoName = "name"
        case repoDescription = "description"
        case forksUrl = "forks_url"
        case numberOfForks = "forks_count"
        case numberOfWatchers = "watchers_count"
        case htmlUrl = "html_url"
        case license
    }
}
