//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

protocol AuthenticationServiceProtocol {
    var apiKey: CurrentValueSubject<String?, Never> { get }
    func login(_ apiKey: String)
    func logout()
}

final class AuthenticationService: AuthenticationServiceProtocol {

    @UserDefault(UserDefaults.apiKeyKey, defaultValue: "")
    private var _privateAPIKey: String {
        didSet {
            apiKey.value = _privateAPIKey.isEmpty ? nil : _privateAPIKey
        }
    }
    
    var apiKey = CurrentValueSubject<String?, Never>(nil)
    
    init() {
        apiKey.value = _privateAPIKey.isEmpty ? nil : _privateAPIKey
    }
    
    func login(_ apiKey: String) {
        _privateAPIKey = apiKey
    }
    
    func logout() {
        _privateAPIKey = ""
    }
}
