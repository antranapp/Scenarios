//
//  MockAuthenticationService.swift
//  Pexels-Production
//
//  Created by An Tran on 10/1/22.
//

import Foundation
import Combine

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
