//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine

final class MockFavouritesManager: FavouritesImageManaging {
    func hasFavourited(_ imageModel: ImageModel) -> Bool {
        false
    }
    
    func fetch() -> Future<ImagesModel, Error> {
        Future { promise in
            return promise(.success(ImagesModel.mock))
        }
    }
    
    func toggle(_ imageModel: ImageModel) {}
}
