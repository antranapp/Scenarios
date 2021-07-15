//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(urlRequestObject: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

// general class with protocol and error handling used for network communication
final class NetworkRequestManager: NetworkManagerProtocol {
    
    private let session: URLSession
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        session = urlSession
    }
    
    func request<T: Decodable>(urlRequestObject: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: urlRequestObject, completionHandler: { [weak self] data, response, error in
            if let errorValue = error {
                completion(.failure(errorValue))
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            // statusCode 200 -> OK, request was successful
            // statusCode 201 -> Created, request was successful, the requested resource was created by server
            // statusCode 204 -> No Content, request ws successful, response does not contain data
            guard httpStatus?.statusCode == 200 || httpStatus?.statusCode == 201 || httpStatus?.statusCode == 204 else {
                let errorString = "unsuccessful request, http code: \(String(describing: httpStatus?.statusCode))"
                let error = NSError(domain: ErrorDomainDescription.networkResponseDomain.rawValue, code: httpStatus?.statusCode ?? ErrorDomainCode.unexpectedResponseFromAPI.rawValue, userInfo: [NSLocalizedDescriptionKey: errorString])
                completion(.failure(error))
                return
            }
            
            guard let dataObject = data else {
                let errorString = "missing data result from request"
                let error = NSError(domain: ErrorDomainDescription.networkResponseDomain.rawValue, code: ErrorDomainCode.missingDataResult.rawValue, userInfo: [NSLocalizedDescriptionKey: errorString])
                completion(.failure(error))
                return
            }
            
            // debugging
            self?.logRateLimiting(for: response)
            
            do {
                let decoder = JSONDecoder()
                let dataFromBackend = try decoder.decode(T.self, from: dataObject)
                completion(.success(dataFromBackend))
            } catch let parsingError {
                let error = NSError(domain: ErrorDomainDescription.networkResponseDomain.rawValue, code: ErrorDomainCode.parseError.rawValue, userInfo: [NSLocalizedDescriptionKey: parsingError.localizedDescription])
                completion(.failure(error))
            }
        })
        
        task.resume()
    }
    
    private func logRateLimiting(for response: URLResponse?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response here: \(String(describing: response))")
            return
        }
        
        let missingHeader = "Missing header"
        let rateLimit = httpResponse.allHeaderFields["X-RateLimit-Limit"] as? String ?? missingHeader
        let rateLimitRemaining = httpResponse.allHeaderFields["X-RateLimit-Remaining"] as? String ?? missingHeader
        let rateLimitReset = httpResponse.allHeaderFields["X-RateLimit-Reset"] as? String ?? missingHeader
        
        print("X-RateLimit-Limit: \(rateLimit)")
        print("X-RateLimit-Remaining: \(rateLimitRemaining)")
        print("X-RateLimit-Reset: \(rateLimitReset)")
    }
}
