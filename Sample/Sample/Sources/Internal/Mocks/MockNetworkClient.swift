//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

final class MockNetworkClient: NetworkClientProtocol {
    
    func perform<T>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let url = Bundle.main.url(forResource: "response", withExtension: "json") else {
            completion(.failure(MockNetworkError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let list = try decoder.decode(T.self, from: data)
            completion(.success(list))
        } catch {
            completion(.failure(error))
        }
    }
}

enum MockNetworkError: Error {
    case fileNotFound
}
