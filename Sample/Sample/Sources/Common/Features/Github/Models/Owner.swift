//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct Owner: Codable {
    let avatarImageUrl: URL?
    let loginName: String
    
    private enum CodingKeys: String, CodingKey {
        case avatarImageUrl = "avatar_url"
        case loginName = "login"
    }
}
