//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

public class ScenarioAppController: RootViewProviding {
    public let rootViewController = UIViewController()

    public var content: RootViewProviding? {
        didSet {
            oldValue?.rootViewController.remove()
            if let content = content {
                rootViewController.addFilling(content.rootViewController)
            }
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
