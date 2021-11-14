//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

final class GithubService {
    
    private var client: NetworkClientProtocol
    
    var numberRetriesLoadRepos = 0
    let maxNumberRetriesLoadRepos = 3

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }
    
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        guard var request = NetworkUtils.makeRequest(url: url, httpMethod: .get) else {
            completion(.failure(GithubServiceError.invalidRequest))
            return
        }
        
        if let accessToken = UserDefaults.standard.object(forKey: Constants.accessTokenKey) as? String {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        client.perform(request: request) { (result: Result<T, Error>) in
            switch result {
            case .success(let successResult):
                self.numberRetriesLoadRepos = 0
                completion(.success(successResult))
            case .failure(let errorValue):
                if self.retry(error: errorValue, url: url, completion: completion) {
                    completion(.failure(errorValue))
                }
            }
        }
    }
    
    func retry<T: Decodable>(error: Error, url: URL, completion: @escaping (Result<T, Error>) -> Void) -> Bool {
        let notAuthorizeError = NetworkUtils.code(from: error)
        
        guard numberRetriesLoadRepos < maxNumberRetriesLoadRepos, notAuthorizeError == 401 || notAuthorizeError == 403 else {
            // github throws another error (not that user is unauthorized)
            // or max retries reached
            // this error we handle normally
            return true
        }
        
        // github throws error that user logged out
        // delete persisted credentials and try again to fetch repos without credentials header
        UserDefaults.standard.removeObject(forKey: Constants.accessTokenKey)
        numberRetriesLoadRepos += 1
        fetch(url: url, completion: completion)
        return false
    }
}

enum GithubServiceError: Error, LocalizedError {
    case invalidRequest
    case notAuthorizeError
}
