//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

enum NetworkUtils {
    static func makeRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }

    static func code(from error: Error) -> Int {
        let errorAsNsError = error as NSError
        return errorAsNsError.code
    }
}
