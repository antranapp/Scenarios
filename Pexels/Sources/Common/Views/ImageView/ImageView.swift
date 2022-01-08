//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    let image: ImageModel
    let favouritesImageManager: FavouritesImageManaging
    
    var body: some View {
        VStack {
            image.imageview()
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    favouritesImageManager.toggle(image)
                } label: {
                    Image(systemName: favouritesImageManager.hasFavourited(image) ? "heart.fill" : "heart")
                }
            }
        }
    }
}
