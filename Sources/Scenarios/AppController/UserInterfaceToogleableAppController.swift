//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI
import UIKit

// swiftlint:disable type_name
public struct UserInterfaceToogleableNavigationAppController: RootViewProviding {
    public var rootViewController: UIViewController

    public init(
        makeChild: (UINavigationController) -> ReloadableViewController
    ) {
        let navigationController = UserInterfaceToogleableNavigationController()
        navigationController.pushViewController(makeChild(navigationController), animated: false)
        rootViewController = navigationController
    }
}

// swiftlint:disable type_name
class UserInterfaceToogleableNavigationController: UINavigationController, UINavigationControllerDelegate {

    private lazy var toggleInterfaceStyleButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "sun.max"),
            style: .plain, target: self, action: #selector(self.didToggleAppearanceMode)
        )
    }()
    
    init() {
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
        viewController.navigationItem.rightBarButtonItem = toggleInterfaceStyleButton
    }
    
    @objc func didToggleAppearanceMode() {
        overrideUserInterfaceStyle = overrideUserInterfaceStyle == .dark ? .light : .dark
        (topViewController as? Reloadable)?.reload()
//
//        if let app = UIApplication.shared.delegate, let window = app.window {
//            window?.overrideUserInterfaceStyle = window?.overrideUserInterfaceStyle == .dark ? .light : .dark
//            (topViewController as? Reloadable)?.reload()
//        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            if traitCollection.userInterfaceStyle == .dark {
                toggleInterfaceStyleButton.image = UIImage(systemName: "moon.circle")
            } else {
                toggleInterfaceStyleButton.image = UIImage(systemName: "sun.max")
            }
        }
    }

}

public protocol Reloadable {
    func reload()
}

public protocol Taggable {
    var tag: Int { get set }
}

public extension Reloadable where Self: Taggable {
    mutating func reload() {
        tag += 1
    }
}

public typealias ReloadableViewController = Reloadable & UIViewController

public final class ReloadableHostingViewController<Content: View & Reloadable>: UIHostingController<Content>, Reloadable {
    
    public func reload() {
        rootView.reload()
    }
}
