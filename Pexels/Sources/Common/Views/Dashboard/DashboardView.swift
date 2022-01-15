//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    private let configuration: Configuration
    
    @StateObject var viewModel: DashboardViewModel
    
    init(configuration: Configuration = .production) {
        self.configuration = configuration
        _viewModel = StateObject(wrappedValue: DashboardViewModel(authenticationService: configuration.authenticationService))
    }
    
    var body: some View {
        if viewModel.isLoggedIn {
            TabView {
                ImagesView(
                    authenticationService: configuration.authenticationService,
                    pexelsImageService: configuration.pexelsImageService,
                    favouritesImageService: configuration.favouritesImageManager
                )
                .tabItem {
                    Image(systemName: "photo")
                    Text("Photos")
                }
                FavouritesView(service: configuration.favouritesImageManager)
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favourites")
                    }
            }
        } else {
            AuthenticationView {
                configuration.authenticationService.login($0)
            }
        }
    }
}
