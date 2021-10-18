//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import UIKit

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
