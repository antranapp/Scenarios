//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

public protocol AudienceTargetable {
    static var audiences: [Audience] { get }
}

extension AudienceTargetable {
    static func canDisplay(for audience: Audience?) -> Bool {
        // Always display when there is no filter.
        guard let audience = audience else {
            return true
        }
        
        // Always display when the audiences list is empty.
        guard !audiences.isEmpty else {
            return true
        }
        
        // Only display the Scenario when the targeted audience
        // is conatined in the audiences list.
        return audiences.contains(audience)
    }
}

public typealias AudienceTargetableScenario = Scenario & AudienceTargetable

public extension AudienceTargetable where Self: AudienceTargetableScenario {
    static var audiences: [Audience] { [.developer] }
}
