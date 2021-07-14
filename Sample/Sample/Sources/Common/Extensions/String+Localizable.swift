//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

extension String {
    // write an extension to read string from Localizable file
    // better readability (or maybe a little bit more beautiful) instead of the direct usage of 'NSLocalizedString'
    static func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
