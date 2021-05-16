//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

public extension UIViewController {

    func showAlert(
        title: String,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        action: UIAlertAction? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let action = action {
            alert.addAction(action)
        }

        present(alert, animated: true, completion: nil)
    }

}
