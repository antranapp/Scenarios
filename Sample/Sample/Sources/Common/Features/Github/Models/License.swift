//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct License: Codable {
    let name: String
    let licenseUrl: URL?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case licenseUrl = "url"
    }
}
