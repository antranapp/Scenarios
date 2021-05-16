//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

public struct BasicAppController: RootViewProviding {

    public var rootViewController: UIViewController
    
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
}
