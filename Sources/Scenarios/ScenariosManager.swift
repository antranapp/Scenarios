//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import UIKit

open class ScenariosManager: BaseScenariosManager {
    
    private var cancellables = Set<AnyCancellable>()
    private var favouriteScenarios = CurrentValueSubject<[ScenarioId], Never>([])
    
    @UserDefault(SettingsKey.favouriteScenarioDefaultKey, defaultValue: [ScenarioId]())
    private var defaultFavouriteScenarios: [ScenarioId]
    
    override public init(
        targetAudience: Audience? = nil,
        plugins: [ScenarioPlugin] = []
    ) {
        super.init(
            targetAudience: targetAudience,
            plugins: plugins
        )
        
        favouriteScenarios.value = defaultFavouriteScenarios
    }
    
    override func setupBindings() {
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

        notificationCenter
            .publisher(for: .selectScenario)
            .sink { notification in
                if let scenarioId = notification.object as? ScenarioId {
                    self.select(scenarioId)
                }
            }
            .store(in: &cancellables)
    }
    
    override func makeScenarioSelector() -> RootViewProviding {
        var innerAppController: RootViewProviding
        if UIDevice.current.userInterfaceIdiom == .pad {
            if #available(iOS 14.0, *) {
                innerAppController = ScenarioSelectorSplitAppController(
                    targetAudience: targetAudience
                ) { [weak self] id in
                    self?.select(id)
                }
            } else {
                innerAppController = ScenarioSelectorAppController(
                    targetAudience: targetAudience,
                    favouriteScenarios: favouriteScenarios,
                    layout: scenarioListLayout
                ) { [weak self] id in
                    self?.select(id)
                }
            }
        } else {
            innerAppController = ScenarioSelectorAppController(
                targetAudience: targetAudience,
                favouriteScenarios: favouriteScenarios,
                layout: scenarioListLayout
            ) { [weak self] id in
                self?.select(id)
            }
        }
        
        return innerAppController
    }
    
    // MARK: Private helpers
    
    private func toggleFavourite(_ scenarioId: ScenarioId) {
        if let index = favouriteScenarios.value.firstIndex(of: scenarioId) {
            favouriteScenarios.value.remove(at: index)
        } else {
            favouriteScenarios.value.append(scenarioId)
        }
        
        defaultFavouriteScenarios = favouriteScenarios.value
    }
}
