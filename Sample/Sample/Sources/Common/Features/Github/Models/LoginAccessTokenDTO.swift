//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct LoginAccessTokenDTO: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
}
