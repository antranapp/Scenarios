//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import SwiftUI

struct FavouritesView: View {
    @StateObject private var viewModel: FavouritesViewModel
    
    init(service: FavouritesImageManaging = FavouritesImageManager()) {
        _viewModel = StateObject(wrappedValue: FavouritesViewModel(service: service))
    }
    
    var body: some View {
        NavigationView {
            StaggeredGrid(columns: 2, list: viewModel.images.images) { image in
                NavigationLink(destination: ImageView(image: image, favouritesImageManager: viewModel.service)) {
                    GridItemView(image: image)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Favourites")
        }
        .onAppear {
            viewModel.fetchImages()
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
