//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

final class MockImageService: ImageServiceProtocol {
    
    var imagesModel: ImagesModel
    var error: Error?
    var delay: TimeInterval?
    
    init(_ imagesModel: ImagesModel = .mock, error: Error? = nil, delay: TimeInterval? = nil) {
        self.imagesModel = imagesModel
        self.error = error
        self.delay = delay
    }
    
    func fetch() -> Future<ImagesModel, Error> {
        Future { promise in
            if let error = self.error {
                return promise(.failure(error))
            }
            
            if let delay = self.delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    promise(.success(self.imagesModel))
                }
                return
            }
            
            return promise(.success(self.imagesModel))
        }
    }
}
