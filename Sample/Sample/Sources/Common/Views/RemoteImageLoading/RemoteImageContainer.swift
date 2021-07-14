//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import UIKit

struct RemoteImageContainer: View {
    @ObservedObject var remoteImageContainerViewModel: RemoteImageContainerViewModel
    
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    
    init(imageUrl: URL?, width: CGFloat = 50, height: CGFloat = 50) {
        imageWidth = width
        imageHeight = height
        remoteImageContainerViewModel = RemoteImageContainerViewModel(imageUrl: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: remoteImageContainerViewModel.imageData.isEmpty ? UIImage(imageLiteralResourceName: "img_loading") : UIImage(data: remoteImageContainerViewModel.imageData)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageWidth, height: imageHeight)
    }
}
