//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

extension ImageModel {
    static let mock = ImageModel(
        thumbnail: .local("1"),
        image: .local("1")
    )
    
    static let failure = ImageModel(
        thumbnail: .remote(URL(string: "https://google.com/fakeimage.png")!),
        image: .remote(URL(string: "https://google.com/fakeimage.png")!)
    )
}
