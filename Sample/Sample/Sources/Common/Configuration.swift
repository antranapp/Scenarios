//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

struct Configuration {
    let docsURL: URL
    let networkClient: NetworkClientProtocol
}

extension Configuration {
    static let production = Configuration(
        docsURL: URL(string: "https://antranapp.github.io/Scenarios/")!,
        networkClient: NetworkClient()
    )
}
