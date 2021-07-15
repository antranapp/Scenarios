//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import UIKit

struct RemoteImageContainer: View {
    @ObservedObject var viewModel: RemoteImageContainerViewModel
    
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    
    init(url: URL?, width: CGFloat = 50, height: CGFloat = 50) {
        imageWidth = width
        imageHeight = height
        viewModel = RemoteImageContainerViewModel(url: url)
    }
    
    var body: some View {
        if viewModel.error {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageWidth, height: imageHeight)
        } else {
            if viewModel.imageData.isEmpty {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageWidth, height: imageHeight)
            } else {
                if let image = UIImage(data: viewModel.imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageHeight)
                } else {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageHeight)
                }
            }
        }
    }
}
