//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

public final class ScenariosAppController: RootViewProviding {
    public let rootViewController = UIViewController()
    
    public var rootViewProvider: RootViewProviding? {
        didSet {
            dismissToRootView()
            oldValue?.rootViewController.remove()
            if let content = rootViewProvider {
                rootViewController.addFilling(content.rootViewController)
            }
        }
    }
    
    func setScenarioSelector(_ rootViewProvider: RootViewProviding) {
        self.rootViewProvider = rootViewProvider
    }
    
    func setScenario(_ id: ScenarioId) {
        if #available(iOS 14.0, *) {
            if let rootViewProvider = rootViewProvider as? ScenarioSelectorSplitAppController {
                rootViewProvider.setScenario(id)
            } else {
                self.rootViewProvider = id.scenarioType.rootViewProvider
            }
        } else {
            self.rootViewProvider = id.scenarioType.rootViewProvider
        }
    }
    
    private func dismissToRootView() {
        if (rootViewProvider?.rootViewController.presentedViewController) != nil {
            rootViewProvider?.rootViewController.dismiss(animated: false, completion: nil)
        }
    }
}

extension UIViewController {
    func addFilling(_ child: UIViewController) {
        addChild(child)
        view.addFillingSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIView {
    func addAutolayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }

    func addFillingSubview(_ subview: UIView, inset: CGFloat = 0) {
        addAutolayoutSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
    }

    func addCenterSubview(_ subview: UIView) {
        addAutolayoutSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
