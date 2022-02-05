//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

class BaseScenarioSelectorAppController: BaseSectionManager, RootViewProviding {

    var rootViewController: UIViewController
    
    private var layout: ScenarioListLayout = .nestedList
    private var targetAudience: Audience?

    private var content: UIViewController? {
        didSet {
            oldValue?.remove()
            if let content = content {
                (rootViewController as! UINavigationController).viewControllers = [content]
                UIAccessibility.post(notification: .screenChanged, argument: nil)
            }
        }
    }
    
    // MARK: Initilizer
    
    override init(
        targetAudience: Audience?,
        select: @escaping (ScenarioId) -> Void
    ) {
        self.targetAudience = targetAudience

        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController = navigationController
        super.init(targetAudience: targetAudience, select: select)

        // For some reasons, the content is not get updated on the first launch
        // on iOS 11. Need to call these explicitly to build up the Scenario Catalog
        content = makeScenarioViewController(with: sections)
        (rootViewController as! UINavigationController).viewControllers = [content!]
    }

     // MARK: Private helpers
    
    override func onDidSetSections(_ sections: [ListSection]) {
        content = makeScenarioViewController(with: sections)
    }

    override func showInfo(_ info: ScenarioInfo) {
        var action: UIAlertAction?
        if let configure = info.configure {
            action = UIAlertAction(
                title: "Configure",
                style: .default,
                handler: { [weak rootViewController] _ in
                    guard let rootViewController = rootViewController else { return }
                    rootViewController.dismiss(animated: true) {
                        configure(rootViewController)
                    }

                }
            )
        }

        rootViewController.showAlert(
            title: info.name,
            message: info.description,
            preferredStyle: .actionSheet,
            action: action
        )
    }
}
