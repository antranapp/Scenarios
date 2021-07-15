//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct RepositoryList: Codable {
    let listItems: [Repository]
    
    private enum CodingKeys: String, CodingKey {
        case listItems = "items"
    }
}
