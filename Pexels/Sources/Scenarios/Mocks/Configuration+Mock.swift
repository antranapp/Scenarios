//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

extension Configuration {
    static let mocking = Configuration(
        name: "Mock",
        authenticationService: MockAuthenticationService(),
        pexelsImageService: MockImageService(),
        favouritesImageManager: MockFavouritesManager()
    )
}
