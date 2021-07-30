//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

public class NavigationAppController: RootViewProviding {
    public var rootViewController: UIViewController

    public init(
        withResetButton: Bool = false,
        withRefreshButton: Bool = false,
        makeChild: (UINavigationController) -> UIViewController
    ) {
        var navigationController: UINavigationController
        if withResetButton || withRefreshButton {
            navigationController = ResetableRefreshableNavigationController(
                hasResetButton: withResetButton,
                hasRefreshButton: withRefreshButton
            )
        } else {
            navigationController = UINavigationController()
        }
        navigationController.pushViewController(makeChild(navigationController), animated: false)
        rootViewController = navigationController
    }
}

class ResetableRefreshableNavigationController: UINavigationController, UINavigationControllerDelegate {

    private let hasResetButton: Bool
    private let hasRefreshButton: Bool
    
    init(
        hasResetButton: Bool = false,
        hasRefreshButton: Bool = false
    ) {
        self.hasResetButton = hasResetButton
        self.hasRefreshButton = hasRefreshButton
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Only add the close button in the RootViewController of the NavigationController
        guard navigationController.viewControllers.count == 1 else { return }

        if hasResetButton {
            let barItem: UIBarButtonItem
            if #available(iOS 13, *) {
                barItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(reset))
            } else {
                barItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(reset))
            }
            viewController.navigationItem.leftBarButtonItem = barItem
        }
        
        if hasRefreshButton {
            let barItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
            viewController.navigationItem.rightBarButtonItem = barItem
        }
    }

    @objc func reset() {
        NotificationCenter.default.post(name: .resetScenario, object: nil)
    }

    @objc func refresh() {
        NotificationCenter.default.post(name: .refreshScenario, object: nil)
    }

}
