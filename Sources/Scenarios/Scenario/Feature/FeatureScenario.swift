//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

public protocol FeatureScenario: AudienceTargetableScenario {
    associatedtype Configuration
    associatedtype Output
    
    static var context: FeatureContext<Configuration, Output> { get }
}
