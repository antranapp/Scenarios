//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

extension ImagesModel {
    static let mock: ImagesModel = .init(
        images: Array(1 ... 10).map {
            ImageModel(thumbnail: .local(String($0)), image: .local(String($0)))
        }
    )
    
    static let mixed: ImagesModel = .init(
        images: Array(1 ... 10).map {
            return ($0 % 2) == 0 ? ImageModel(thumbnail: .local(String($0)), image: .local(String($0))) : .failure
        }
    )
}
