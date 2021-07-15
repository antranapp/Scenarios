//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

enum NetworkUtils {
    // request object without body data
    static func makeRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest? {
        // use standard cache policy and time interval
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
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
