//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class GithubRepositoryDetailScenario: Scenario {
    static var name: String = "Detail"
    static var kind: ScenarioKind = .screen
    static var category: ScenarioCategory? = "Github"
    
    static var rootViewProvider: RootViewProviding {
        let detailView = RepositoryDetailView(repository: .alamofire)
        return BasicAppController(rootViewController: UIHostingController(rootView: detailView))
    }
}

private extension Repository {
    static let alamofire = Repository(
        id: 7774181,
        repoName: "Alamofire",
        owner: Owner(
            avatarImageUrl: URL(string: "https://avatars.githubusercontent.com/u/7774181?v=4"),
            loginName: "Alamofire"
        ),
        numberOfForks: 6762,
        numberOfWatchers: 35965,
        repoDescription: "Elegant HTTP Networking in Swift",
        forksUrl: URL(string: "https://api.github.com/repos/Alamofire/Alamofire/forks"),
        htmlUrl: URL(string: "https://github.com/Alamofire/Alamofire")!,
        license: License(
            name: "MIT License",
            licenseUrl: URL(string: "https://api.github.com/licenses/mit")
        )
    )
}
