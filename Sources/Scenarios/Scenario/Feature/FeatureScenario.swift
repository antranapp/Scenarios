//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
public protocol FeatureScenario: AudienceTargetableScenario {
    associatedtype Configuration
    associatedtype Output
    
    static var context: FeatureContext<Configuration, Output> { get }
}

extension FeatureScenario {
    public static var kind: ScenarioKind {
        .feature
    }
}
