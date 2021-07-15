//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

enum NetworkRequestUtils {
    // request object without body data
    static func makeRequestObjectFor(url: URL, httpMethod: HTTPMethod) -> URLRequest? {
        // use standard cache policy and time interval
        var backendRequest = URLRequest(url: url)
        backendRequest.httpMethod = httpMethod.rawValue
                
        print("url: \(backendRequest.url?.absoluteString ?? "missing backendRequest.url")")
        return backendRequest
    }

    // make request object with body data (example post/put)
    static func makeRequestObjectWithRequestBodyFor<T: Encodable>(url: URL, httpMethod: HTTPMethod, requestObject: T) -> URLRequest? {
        var backendRequest = makeRequestObjectFor(url: url, httpMethod: httpMethod)

        let encoder = JSONEncoder()
        guard let httpBody = try? encoder.encode(requestObject) else { return nil }
        backendRequest?.httpBody = httpBody
        
        return backendRequest
    }
    
    static func errorCreatingRequestObject() -> Error {
        let errorString = "Cannot create request object here"
        let error = NSError(domain: ErrorDomainDescription.networkRequestDomain.rawValue, code: ErrorDomainCode.errorWhenCreateRequestObject.rawValue, userInfo: [NSLocalizedDescriptionKey: errorString])
        return error
    }
    
    static func errorCodeFrom(error: Error) -> Int {
        let errorAsNsError = error as NSError
        return errorAsNsError.code
    }
}
