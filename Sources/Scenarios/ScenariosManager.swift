
import Combine
import UIKit

@available(iOS 13.0, *)
open class ScenariosManager: BaseScenariosManager {
    
    private var cancellables = Set<AnyCancellable>()
    @Published private var favouriteScenarios: [ScenarioId]
    
    public override init(
        targetAudience: Audience? = nil,
        plugins: [ScenarioPlugin] = []
    ) {
        favouriteScenarios = UserDefaults.standard.object(
            for: ScenariosManager.favouriteScenarioDefaultKey,
               defaultValue: [ScenarioId]()
        )
        super.init(
            targetAudience: targetAudience,
            plugins: plugins)
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
    }
    
    override func updateContent() {
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
    
    // MARK: Private helpers
    
    private func toggleFavourite(_ scenarioId: ScenarioId) {
        if let index = favouriteScenarios.firstIndex(of: scenarioId) {
            favouriteScenarios.remove(at: index)
        } else {
            favouriteScenarios.append(scenarioId)
        }
    }
}
