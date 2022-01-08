//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

enum ViewState<T: Hashable> {
    case loading
    case loaded(value: T)
    case failed(error: Swift.Error)
}

extension ViewState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let leftValue), .loaded(let rightValue)):
            return leftValue == rightValue
        case (.failed(let leftError as NSError), .failed(let rightError as NSError)):
            return leftError == rightError
        default:
            return false
        }
    }
}

final class ImagesViewModel: ObservableObject {
    
    @Published var viewState: ViewState<ImagesModel> = .loading
    
    private let service: ImageServiceProtocol
    
    private var subscription: AnyCancellable?
    
    private var hasFetchedOnAppear: Bool = false
    
    init(service: ImageServiceProtocol) {
        self.service = service
    }
    
    func fetchImagesOnAppear() {
        guard !hasFetchedOnAppear else { return }
        hasFetchedOnAppear = true
        fetchImages()
    }
    
    func fetchImages() {
        subscription?.cancel()
        subscription = service.fetch().sink(
            receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    DispatchQueue.main.async {
                        self?.viewState = .failed(error: error)
                    }
                }
            },
            receiveValue: { [weak self] imagesModel in
                DispatchQueue.main.async {
                    self?.viewState = .loaded(value: imagesModel)
                }
            }
        )
    }
}
