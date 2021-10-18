//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import UIKit

final class PrototypeScenario: Scenario {
    static var name: String = "Prototype"
    static var kind: ScenarioKind = .prototype

    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            ViewController()
        }
    }
}

private final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let label = UILabel()
        label.text = "Prototype"

        view.addCenterSubview(label)
    }
}
