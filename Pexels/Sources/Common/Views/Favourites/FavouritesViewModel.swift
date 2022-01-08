//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

final class FavouritesViewModel: ObservableObject {
    @Published var images: ImagesModel = .init(images: [])
    
    let service: FavouritesImageManaging
    
    private var subscription: AnyCancellable?
    
    init(service: FavouritesImageManaging) {
        self.service = service
    }

    func fetchImages() {
        subscription?.cancel()
        subscription = service.fetch().sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            },
            receiveValue: { [weak self] imageListModel in
                DispatchQueue.main.async {
                    self?.images = imageListModel
                }
            }
        )
    }
}
