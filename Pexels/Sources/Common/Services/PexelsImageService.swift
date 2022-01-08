//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

protocol ImageServiceProtocol {
    func fetch() -> Future<ImagesModel, Error>
    func search(_ term: String) -> Future<ImagesModel, Error>
}

extension ImageServiceProtocol {
    func search(_ term: String) -> Future<ImagesModel, Error> {
        fetch()
    }
}

final class PexelsImageService: ImageServiceProtocol {
    
    private let authenticationService: AuthenticationService
    private var client: NetworkClientProtocol

    public init(
        client: NetworkClientProtocol = NetworkClient(),
        authenticationService: AuthenticationService
    ) {
        self.authenticationService = authenticationService
        self.client = client
    }
    
    func fetch() -> Future<ImagesModel, Error> {
        let urlString = "https://api.pexels.com/v1/curated?per_page=30"
        let url = URL(string: urlString)!
        
        return Future { resolver in
            guard let apiKey = self.authenticationService.apiKey.value else {
                resolver(Result.failure(ServiceNetworkError.notAuthenticated))
                return
            }

            var request = URLRequest(url: url)
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")

            self.client.perform(request: request) { (result: Result<Photos, Error>) in
                switch result {
                case .success(let photos):
                    let images = ImagesModel(from: photos)
                    return resolver(Result.success(images))
                case .failure(let errorValue):
                    return resolver(.failure(errorValue))
                }
            }
        }
    }

    func search(_ term: String) -> Future<ImagesModel, Error> {
        let urlString = "https://api.pexels.com/v1/search?query=\(term)&per_page=30"
        let url = URL(string: urlString)!

        return Future { resolver in
            guard let apiKey = self.authenticationService.apiKey.value else {
                resolver(Result.failure(ServiceNetworkError.notAuthenticated))
                return
            }

            var request = URLRequest(url: url)
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")

            self.client.perform(request: request) { (result: Result<Photos, Error>) in
                switch result {
                case .success(let photos):
                    let images = ImagesModel(from: photos)
                    return resolver(Result.success(images))
                case .failure(let errorValue):
                    return resolver(.failure(errorValue))
                }
            }
        }
    }
}

private struct Photo: Decodable {
    let url: String
    let photographer: String
    let photographer_url: String
    let src: PhotoSource
}

private struct PhotoSource: Decodable {
    let original: String
    let tiny: String
}

private struct Photos: Decodable {
    let photos: [Photo]
}

private extension ImageModel {
    init(from photo: Photo) {
        self = ImageModel(
            thumbnail: .remote(URL(string: photo.src.tiny)!),
            image: .remote(URL(string: photo.src.original)!)
        )
    }
}

private extension ImagesModel {
    init(from photos: Photos) {
        self.init(images: photos.photos.map(ImageModel.init))
    }
}

enum ServiceNetworkError: Error {
    case notAuthenticated
    case noData
    case httpError(_ error: Error)
    case parsingError(_ error: Error)
}
