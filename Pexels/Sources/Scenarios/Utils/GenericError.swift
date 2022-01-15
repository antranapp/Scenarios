//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct GenericError: Error, LocalizedError {
    let description: String
    
    var errorDescription: String? {
        description
    }
}
