//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct Configuration {
    let name: String
    let authenticationService: AuthenticationServiceProtocol
    let pexelsImageService: ImageServiceProtocol
    let favouritesImageManager: FavouritesImageManaging
}

extension Configuration {
    static let production: Configuration = {
        let authenticationService = AuthenticationService()
        return Configuration(
            name: "Production",
            authenticationService: authenticationService,
            pexelsImageService: PexelsImageService(authenticationService: authenticationService),
            favouritesImageManager: FavouritesImageManager()
        )
    }()
}
