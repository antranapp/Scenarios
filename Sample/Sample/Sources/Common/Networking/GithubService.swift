//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

class GithubService: ObservableObject {
    
    private var networkRequestHelper: NetworkManagerProtocol
    
    var numberRetriesLoadRepos = 0
    let maxNumberRetriesLoadRepos = 3

    init(networkHelper: NetworkManagerProtocol = NetworkRequestManager()) {
        networkRequestHelper = networkHelper
    }
    
    func fetch<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlValue = url, let requestObject = NetworkRequestUtils.makeRequestObjectFor(url: urlValue, httpMethod: .get) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkRequestUtils.errorCreatingRequestObject()))
            }
            
            return
        }
        
//        if let localPersistedAuthObject: LoginAccessTokenDTO = UserDefaults.standard.getObject(forKey: GitHubExplorerAppCreds.persistedLoginObject) {
//            requestObject.addValue("\(localPersistedAuthObject.tokenType) \(localPersistedAuthObject.accessToken)", forHTTPHeaderField: "Authorization")
//        }
        
        networkRequestHelper.request(urlRequestObject: requestObject) { (result: Result<T, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let successResult):
                    self.numberRetriesLoadRepos = 0
                    completion(.success(successResult))
                case .failure(let errorValue):
                    if self.returnErrorWhenFetchRepos(error: errorValue, url: url, completion: completion) {
                        completion(.failure(errorValue))
                    }
                }
            }
        }
    }
    
    func returnErrorWhenFetchRepos<T: Decodable>(error: Error, url: URL?, completion: @escaping (Result<T, Error>) -> Void) -> Bool {
        let notAuthorizeError = NetworkRequestUtils.errorCodeFrom(error: error)
        
        guard numberRetriesLoadRepos < maxNumberRetriesLoadRepos, notAuthorizeError == 401 || notAuthorizeError == 403 else {
            // github throws another error (not that user is unauthorized)
            // or max retries reached
            // this error we handle normally
            return true
        }
        
        // github throws error that user logged out
        // delete persisted credentials and try again to fetch repos without credentials header
        UserDefaults.standard.removeObject(forKey: GitHubExplorerAppCreds.persistedLoginObject)
        numberRetriesLoadRepos += 1
        fetch(url: url, completion: completion)
        return false
    }
}
