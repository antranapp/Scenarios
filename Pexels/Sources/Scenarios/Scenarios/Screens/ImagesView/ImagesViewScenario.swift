//
// Copyright © 2021 An Tran. All rights reserved.
//

import Scenarios
import SwiftUI

final class ImagesViewMockLoadingCaseScenario: Scenario {
    static var name: String = "Mock - Loading Case"
    static var kind: ScenarioKind = .screen
    static var category: ScenarioCategory? = "ImagesView"
    
    static var rootViewProvider: RootViewProviding {
        BasicAppController(
            rootViewController: UIHostingController(
                rootView: ImagesView(
                    authenticationService: MockAuthenticationService(),
                    pexelsImageService: MockImageService(delay: 100),
                    favouritesImageService: MockFavouritesManager()
                )
            )
        )
    }
}

final class ImagesViewMockHappyCaseScenario: Scenario {
    static var name: String = "Mock - Happy Case"
    static var kind: ScenarioKind = .screen
    static var category: ScenarioCategory? = "ImagesView"
    
    static var rootViewProvider: RootViewProviding {
        BasicAppController(
            rootViewController: UIHostingController(
                rootView: ImagesView(
                    authenticationService: MockAuthenticationService(),
                    pexelsImageService: MockImageService(),
                    favouritesImageService: MockFavouritesManager()
                )
            )
        )
    }
}

final class ImagesViewMockErrorCaseScenario: Scenario {
    static var name: String = "Mock - Error Case"
    static var kind: ScenarioKind = .screen
    static var category: ScenarioCategory? = "ImagesView"
    
    static var rootViewProvider: RootViewProviding {
        BasicAppController(
            rootViewController: UIHostingController(
                rootView: ImagesView(
                    authenticationService: MockAuthenticationService(),
                    pexelsImageService: MockImageService(error: GenericError(description: "mock-error")),
                    favouritesImageService: MockFavouritesManager()
                )
            )
        )
    }
}

final class ImagesViewMockMixedResultScenario: Scenario {
    static var name: String = "Mock - Mixed Result"
    static var kind: ScenarioKind = .screen
    static var category: ScenarioCategory? = "ImagesView"
    
    static var rootViewProvider: RootViewProviding {
        BasicAppController(
            rootViewController: UIHostingController(
                rootView: ImagesView(
                    authenticationService: MockAuthenticationService(),
                    pexelsImageService: MockImageService(.mixed),
                    favouritesImageService: MockFavouritesManager()
                )
            )
        )
    }
}

final class ImagesViewProductionScenario: Scenario {
    static var name: String = "Production"
    static var kind: ScenarioKind = .screen
    static var category: ScenarioCategory? = "ImagesView"
    
    static var rootViewProvider: RootViewProviding {
        let authService = AuthenticationService()
        authService.login("563492ad6f917000010000014d518d4e04d146a488ae371110cd2f35")
        return BasicAppController(
            rootViewController: UIHostingController(
                rootView: ImagesView(
                    authenticationService: authService,
                    pexelsImageService: PexelsImageService(authenticationService: authService),
                    favouritesImageService: FavouritesImageManager()
                )
            )
        )
    }
}
