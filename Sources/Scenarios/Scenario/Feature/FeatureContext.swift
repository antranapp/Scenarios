//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation
import UIKit

@available(iOS 13.0, *)
public class FeatureContext<Configuration, Output> {
    let configurations: [Configuration]
    var selectedConfiguration: Configuration?
    var didSelect: (Configuration) -> AnyPublisher<Output, Error>
    var didPrepare: (Output) -> AnyPublisher<UIViewController, Error>
    
    public init(
        configurations: [Configuration],
        didSelect: @escaping (Configuration) -> AnyPublisher<Output, Error>,
        didPrepare: @escaping (Output) -> AnyPublisher<UIViewController, Error>
    ) {
        self.configurations = configurations
        self.didSelect = didSelect
        self.didPrepare = didPrepare
    }
}
