//
// Copyright © 2021 An Tran. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
#endif
import UIKit

// swiftlint:disable type_name
@available(iOS 13.0, *)
public class UserInterfaceToogleableNavigationAppController: NavigationAppController {

    public init(
        withResetButton: Bool = false,
        withRefreshButton: Bool = false,
        makeChild: (UINavigationController) -> ReloadableViewController
    ) {
        let navigationController = UserInterfaceToogleableNavigationController(
            hasResetButton: withResetButton,
            hasRefreshButton: withResetButton
        )
        super.init(
            navigationController: navigationController,
            makeChild: makeChild
        )
    }
}

@available(iOS 13.0, *)
class UserInterfaceToogleableNavigationController: ResetableRefreshableNavigationController {

    private lazy var toggleInterfaceStyleButton: UIBarButtonItem = .init(
        image: UIImage(systemName: "sun.max"),
        style: .plain, target: self, action: #selector(self.didToggleAppearanceMode)
    )

    override init(
        hasResetButton: Bool = false,
        hasRefreshButton: Bool = false
    ) {
        super.init(hasResetButton: hasResetButton, hasRefreshButton: hasRefreshButton)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        super.navigationController(navigationController, willShow: viewController, animated: animated)
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

@available(iOS 13.0, *)
public final class ReloadableHostingViewController<Content: View & Reloadable>: UIHostingController<Content>, Reloadable {
    
    public func reload() {
        rootView.reload()
    }
}
