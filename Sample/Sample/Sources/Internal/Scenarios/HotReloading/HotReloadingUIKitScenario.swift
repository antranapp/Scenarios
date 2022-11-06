//
// Copyright © 2022 An Tran. All rights reserved.
//

import Foundation
import Inject
import Scenarios
import SwiftUI

public final class HotReloadingUIKitScenario: Scenario {
    public static var name: String = "UIKit"
    public static var kind: ScenarioKind = .prototype
    public static var category: ScenarioCategory? = "Hot Reloading"
    
    public static var rootViewProvider: RootViewProviding {
        BasicAppController(
            rootViewController: Inject.ViewControllerHost(ViewController())
        )
    }
}

private class ViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "UIKit: Hot Reloading"
        label.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .vertical
        
        view.addFillingSubview(stackView)
    }
}
