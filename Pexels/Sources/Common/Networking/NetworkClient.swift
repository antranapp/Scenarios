//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    func perform<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

// general class with protocol and error handling used for network communication
final class NetworkClient: NetworkClientProtocol {
    
    private let session: URLSession
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        session = urlSession
    }
    
    func perform<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let errorValue = error {
                completion(.failure(errorValue))
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            // statusCode 200 -> OK, request was successful
            // statusCode 201 -> Created, request was successful, the requested resource was created by server
            // statusCode 204 -> No Content, request was successful, response does not contain data
            guard httpStatus?.statusCode == 200 || httpStatus?.statusCode == 201 || httpStatus?.statusCode == 204 else {
                let errorString = "unsuccessful request, http code: \(String(describing: httpStatus?.statusCode))"
                let error = NSError(domain: ErrorDomainDescription.networkResponseDomain.rawValue, code: httpStatus?.statusCode ?? ErrorDomainCode.unexpectedResponseFromAPI.rawValue, userInfo: [NSLocalizedDescriptionKey: errorString])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let errorString = "missing data result from request"
                let error = NSError(domain: ErrorDomainDescription.networkResponseDomain.rawValue, code: ErrorDomainCode.missingDataResult.rawValue, userInfo: [NSLocalizedDescriptionKey: errorString])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dataFromBackend = try decoder.decode(T.self, from: data)
                completion(.success(dataFromBackend))
            } catch let parsingError {
                let error = NSError(domain: ErrorDomainDescription.networkResponseDomain.rawValue, code: ErrorDomainCode.parseError.rawValue, userInfo: [NSLocalizedDescriptionKey: parsingError.localizedDescription])
                completion(.failure(error))
            }
        })
        
        task.resume()
    }
}
