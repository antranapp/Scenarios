//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

open class BaseScenariosManager {

    // MARK: Properties

    public static let activeScenarioDefaultKey = "activeScenario"
    public static let favouriteScenarioDefaultKey = "favouriteScenarios"
    public static let scenarioListLayoutDefaultKey = "scenarioListLayout"
    public static let interfaceStyleDefaultKey = "interfaceStyle"
    public static let disableAnimations = "disable_animations"
    public static let disableHardwareKeyboard = "disable_hardware_keyboard"

    public let appController = ScenariosAppController()

    let targetAudience: Audience?

    @UserDefault(BaseScenariosManager.favouriteScenarioDefaultKey, defaultValue: [ScenarioId]())
    private var defaultFavouriteScenarios: [ScenarioId]

    @UserDefault(BaseScenariosManager.activeScenarioDefaultKey)
    var activeScenarioId: ScenarioId? {
        didSet {
            updateContent()
        }
    }

    @UserDefault(BaseScenariosManager.scenarioListLayoutDefaultKey, defaultValue: .nestedList)
    var scenarioListLayout: ScenarioListLayout {
        didSet {
            updateContent()
        }
    }

    private lazy var shortcuts: [ApplicationShortcutItem] = [
        ApplicationShortcutItem(
            type: "resetActiveScenario",
            title: "Reset Scenario",
            systemImageName: "arrowtriangle.left.circle",
            action: { [weak self] in
                self?.reset()
            }
        ),
        ApplicationShortcutItem(
            type: "openSettings",
            title: "Settings",
            systemImageName: "gear",
            action: {
                DispatchQueue.main.async {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        ),
    ]

    // Note: Hold onto the plugins to keep them in memory.
    private let plugins: [ScenarioPlugin]
    
    private var isInitialLaunch = true

    // MARK: Public APIs

    public init(
        targetAudience: Audience? = nil,
        plugins: [ScenarioPlugin] = []
    ) {
        self.targetAudience = targetAudience
        self.plugins = plugins

        self.plugins.forEach { $0.register() }

        updateShortcuts()

        setupBindings()
        updateContent()
        
        isInitialLaunch = false
    }

    public func append(shortcuts: [ApplicationShortcutItem]) {
        self.shortcuts += shortcuts
        updateShortcuts()
    }

    public func prepare(_ window: UIWindow) {
        window.accessibilityLabel = "MainWindow"
        if let disableAnimations = Int(ProcessInfo.processInfo.environment[Self.disableAnimations] ?? ""),
           disableAnimations > 0
        {
            UIView.setAnimationsEnabled(false)
            window.layer.speed = 2000
        }

        if let disableHardwareKeyboard = Int(ProcessInfo.processInfo.environment[Self.disableHardwareKeyboard] ?? ""),
           disableHardwareKeyboard > 0
        {
            // From https://stackoverflow.com/a/57618331
            let setHardwareLayout = NSSelectorFromString("setHardwareLayout:")
            UITextInputMode.activeInputModes
                .filter { $0.responds(to: setHardwareLayout) }
                .forEach { $0.perform(setHardwareLayout, with: nil) }
        }

        if #available(iOS 13.0, *) {
            switch UserDefaults.standard.string(forKey: Self.interfaceStyleDefaultKey) {
            case "dark":
                window.overrideUserInterfaceStyle = .dark
            case "light":
                window.overrideUserInterfaceStyle = .light
            default:
                break
            }
        }
    }

    public func performAction(for shortcutItem: UIApplicationShortcutItem) -> Bool {
        for shortcut in shortcuts where shortcut.item.type == shortcutItem.type {
            shortcut.action()
            return true
        }
        return false
    }

    public func makeAppController() -> RootViewProviding {
        appController
    }

    @objc public func reset() {
        activeScenarioId = nil
    }

    // MARK: Private helpers

    private func updateShortcuts() {
        UIApplication.shared.shortcutItems = shortcuts.map(\.item)
    }

    func setupBindings() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(reset), name: .resetScenario, object: nil)
    }

    func updateContent() {
        if let activeScenarioId = activeScenarioId {
            if isInitialLaunch {
                appController.setScenarioSelector(makeScenarioSelector())
            }
            appController.setScenario(activeScenarioId)
        } else {
            appController.setScenarioSelector(makeScenarioSelector())
        }
    }
    
    func makeScenarioSelector() -> RootViewProviding {
        BaseScenarioSelectorAppController(
            targetAudience: targetAudience
        ) { [weak self] id in
            self?.activeScenarioId = id
        }
    }

    @objc func refresh() {
        let previsousScenarioId = activeScenarioId
        activeScenarioId = nil

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            DispatchQueue.main.async {
                self?.activeScenarioId = previsousScenarioId
            }
        }
    }

    @objc func switchLayout() {
        switch scenarioListLayout {
        case .nestedList:
            scenarioListLayout = .outlineList
        case .outlineList:
            scenarioListLayout = .nestedList
        }
    }
}

public protocol ScenarioPlugin {
    func register()
}

enum ScenarioListLayout: String {
    case nestedList
    case outlineList
}
