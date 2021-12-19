//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct SwiftUIViewProvider: UIViewControllerRepresentable {
    let rootViewProvider: RootViewProviding
    
    public init(_ rootViewProvider: RootViewProviding) {
        self.rootViewProvider = rootViewProvider
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        rootViewProvider.rootViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Doing nothing
    }

}
