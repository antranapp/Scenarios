//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class RepositoryRowViewScenario: Scenario {
    static var name: String = "Repository Row"
    static var kind: ScenarioKind = .component
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: ContentView())
        }
    }
}

private struct ContentView: View {
    var body: some View {
        VStack(spacing: 32) {
            RepositoryRowView(repository: .repo1)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            Divider()
            
            RepositoryRowView(repository: .repo2)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            Divider()
            
            RepositoryRowView(repository: .repoNoAvatar)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            Divider()

            RepositoryRowView(repository: .repoWithVeryLongName)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
    }
}

private extension Repository {
    static let repo1 = Repository(
        id: 1,
        repoName: "awesome-ios",
        owner: Owner(
            avatarImageUrl: URL(string: "https://avatars.githubusercontent.com/u/484656?v=4"),
            loginName: "vsouza"
        ),
        numberOfForks: 6318,
        numberOfWatchers: 37934,
        repoDescription: "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects",
        forksUrl: nil,
        htmlUrl: URL(string: "https://github.com/vsouza/awesome-ios")!,
        license: License(name: "MIT License", licenseUrl: URL(string: "https://api.github.com/licenses/mit")!)
    )
    
    static let repo2 = Repository(
        id: 2,
        repoName: "Alamofire",
        owner: Owner(
            avatarImageUrl: URL(string: "https://avatars.githubusercontent.com/u/7774181?v=4"),
            loginName: "Alamofire"
        ),
        numberOfForks: 2321,
        numberOfWatchers: 65464,
        repoDescription: "Elegant HTTP Networking in Swift",
        forksUrl: nil,
        htmlUrl: URL(string: "https://github.com/Alamofire/Alamofire")!,
        license: License(name: "MIT License", licenseUrl: URL(string: "https://api.github.com/licenses/mit")!)
    )
    
    static let repoNoAvatar = Repository(
        id: 2,
        repoName: "No Avatar Repository",
        owner: Owner(
            avatarImageUrl: nil,
            loginName: "fakeOwner"
        ),
        numberOfForks: 2321,
        numberOfWatchers: 65464,
        repoDescription: "This is a fake repository",
        forksUrl: nil,
        htmlUrl: URL(string: "https://github.com/fakeRepo/NoAvatarRepository")!,
        license: License(name: "MIT License", licenseUrl: URL(string: "https://api.github.com/licenses/mit")!)
    )

    static let repoWithVeryLongName = Repository(
        id: 2,
        repoName: "This is a very long very long very long very long very long name",
        owner: Owner(
            avatarImageUrl: nil,
            loginName: "fakeOwner"
        ),
        numberOfForks: 2321,
        numberOfWatchers: 65464,
        repoDescription: "This is a fake repository",
        forksUrl: nil,
        htmlUrl: URL(string: "https://github.com/fakeRepo/NoAvatarRepository")!,
        license: License(name: "MIT License", licenseUrl: URL(string: "https://api.github.com/licenses/mit")!)
    )

}
