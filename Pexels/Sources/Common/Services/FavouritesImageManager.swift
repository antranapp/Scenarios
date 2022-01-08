//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

protocol FavouritesImageManaging: ImageServiceProtocol {
    func toggle(_ imageModel: ImageModel)
    func hasFavourited(_ imageModel: ImageModel) -> Bool
}

final class FavouritesImageManager: FavouritesImageManaging {

    @UserDefault(codableKey: UserDefaults.favouritesPhotosKey, defaultValue: ImagesModel(images: []))
    private var _privateImages: ImagesModel
    
    func fetch() -> Future<ImagesModel, Error> {
        Future { promise in
            return promise(.success(self._privateImages))
        }
    }
    
    func toggle(_ imageModel: ImageModel) {
        if hasFavourited(imageModel) {
            _privateImages.images.removeAll(where: { $0.thumbnail == imageModel.thumbnail })
        } else {
            _privateImages.images.append(imageModel)
        }
    }
    
    func hasFavourited(_ imageModel: ImageModel) -> Bool {
        _privateImages.images.first(where: { $0.thumbnail == imageModel.thumbnail }) != nil
    }
}
