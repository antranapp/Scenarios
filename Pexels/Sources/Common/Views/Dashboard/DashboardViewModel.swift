//
//  DashboardViewModel.swift
//  Pexels-Production
//
//  Created by An Tran on 10/1/22.
//

import Foundation
import Combine

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
