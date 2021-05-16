//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import UIKit

open class ScenariosManager {

    // MARK: Properties

    public static let activeScenarioDefaultKey = "activeScenario"
    public static let favouriteScenarioDefaultKey = "favouriteScenarios"
    public static let scenarioListLayoutDefaultKey = "scenarioListLayout"
    public static let interfaceStyleDefaultKey = "interfaceStyle"
    public static let disableAnimations = "disable_animations"
    public static let disableHardwareKeyboard = "disable_hardware_keyboard"

    public let appController = ScenarioAppController()

    private let targetAudience: Audience?
    private var cancellables = Set<AnyCancellable>()

    @UserDefault(ScenariosManager.favouriteScenarioDefaultKey, defaultValue: [ScenarioId]())
    private var defaultFavouriteScenarios: [ScenarioId]
    
    @Published private var favouriteScenarios: [ScenarioId]

    @UserDefault(ScenariosManager.activeScenarioDefaultKey)
    private var activeScenarioId: ScenarioId? {
        didSet {
            updateContent()
        }
    }

    @UserDefault(ScenariosManager.scenarioListLayoutDefaultKey, defaultValue: .nestedList)
    private var scenarioListLayout: ScenarioListLayout {
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

    // MARK: Public APIs

    public init(
        targetAudience: Audience? = nil,
        plugins: [ScenarioPlugin] = []
    ) {
        self.targetAudience = targetAudience
        self.plugins = plugins
        favouriteScenarios = UserDefaults.standard.object(
            for: ScenariosManager.favouriteScenarioDefaultKey,
            defaultValue: [ScenarioId]()
        )
        
        UIApplication.shared.shortcutItems = shortcuts.map(\.item)
        
        self.plugins.forEach { $0.register() }

        updateShortcuts()

        setupBindings()
        updateContent()
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

    public func reset() {
        if (appController.content?.rootViewController.presentedViewController) != nil {
            appController.content?.rootViewController.dismiss(animated: false, completion: nil)
        }
        activeScenarioId = nil
    }

    // MARK: Private helpers

    private func updateShortcuts() {
        UIApplication.shared.shortcutItems = shortcuts.map(\.item)
    }

    private func setupBindings() {
        let notificationCenter = NotificationCenter.default
        notificationCenter
            .publisher(for: .resetScenario)
            .sink { _ in
                self.reset()
            }
            .store(in: &cancellables)

        notificationCenter
            .publisher(for: .refreshScenario)
            .sink { _ in
                self.refresh()
            }
            .store(in: &cancellables)

        notificationCenter
            .publisher(for: .switchLayout)
            .sink { _ in
                self.switchLayout()
            }
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: .toggleFavourite)
            .sink { notification in
                if let scenarioId = notification.object as? ScenarioId {
                    self.toggleFavourite(scenarioId)
                }
            }
            .store(in: &cancellables)
    }

    private func updateContent() {
        if let activeScenarioId = activeScenarioId {
            appController.content = activeScenarioId.scenarioType.rootViewProvider
        } else {
            appController.content?.rootViewController.remove()
            appController.content = nil
            appController.content = ScenarioSelectorAppController(
                targetAudience: targetAudience,
                favouriteScenarios: $favouriteScenarios.eraseToAnyPublisher(),
                layout: scenarioListLayout
            ) { [weak self] id in
                self?.activeScenarioId = id
            }
        }
    }

    private func refresh() {
        if (appController.content?.rootViewController.presentedViewController) != nil {
            appController.content?.rootViewController.dismiss(animated: false, completion: nil)
        }
        
        let previsousScenarioId = activeScenarioId
        activeScenarioId = nil
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            DispatchQueue.main.async {
                self?.activeScenarioId = previsousScenarioId
            }
        }
    }
    
    private func switchLayout() {
        switch scenarioListLayout {
        case .nestedList:
            scenarioListLayout = .outlineList
        case .outlineList:
            scenarioListLayout = .nestedList
        }
    }
    
    private func toggleFavourite(_ scenarioId: ScenarioId) {
        if let index = favouriteScenarios.firstIndex(of: scenarioId) {
            favouriteScenarios.remove(at: index)
        } else {
            favouriteScenarios.append(scenarioId)
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
