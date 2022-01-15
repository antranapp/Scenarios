//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

final class MockAuthenticationService: AuthenticationServiceProtocol {
    let apiKey = CurrentValueSubject<String?, Never>(nil)
    
    init(apiKey: String? = nil) {
        self.apiKey.value = apiKey
    }
    
    func login(_ apiKey: String) {
        self.apiKey.value = apiKey
    }
    
    func logout() {
        self.apiKey.value = nil
    }
}
