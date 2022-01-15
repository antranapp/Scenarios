//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

final class DashboardViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    
    var connection: AnyCancellable?
    
    private let authenticationService: AuthenticationServiceProtocol
    
    init(authenticationService: AuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
        connection = authenticationService.apiKey.sink(receiveValue: { [weak self] apiKey in
            self?.isLoggedIn = apiKey != nil
        })
    }
    
    func logout() {
        authenticationService.logout()
    }
}
