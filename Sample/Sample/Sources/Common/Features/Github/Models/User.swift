//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct User: Codable {
    let loginUsername: String
    let avatarUrl: URL
    let githubPageHtml: URL
    let repos_url: URL?
    let name: String
    let company: String?
    let location: String?
    
    private enum CodingKeys: String, CodingKey {
        case loginUsername = "login"
        case avatarUrl = "avatar_url"
        case githubPageHtml = "html_url"
        case repos_url
        case name
        case company
        case location
    }
}
