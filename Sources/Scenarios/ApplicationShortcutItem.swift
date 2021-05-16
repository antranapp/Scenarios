//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

public struct ApplicationShortcutItem {
    var item: UIApplicationShortcutItem
    var action: () -> Void
}

public extension ApplicationShortcutItem {
    init(
        type: String,
        title: String,
        systemImageName: String,
        action: @escaping () -> Void
    ) {

        let icon: UIApplicationShortcutIcon?
        if #available(iOS 13.0, *) {
            icon = UIApplicationShortcutIcon(systemImageName: systemImageName)
        } else {
            icon = nil
        }
        self.init(
            item: UIApplicationShortcutItem(
                type: type,
                localizedTitle: title,
                localizedSubtitle: nil,
                icon: icon,
                userInfo: nil
            ),
            action: action
        )
    }
}
