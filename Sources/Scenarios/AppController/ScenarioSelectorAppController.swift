//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

@available(iOS 13.0, *)
final class ScenarioSelectorAppController: BaseScenarioSelectorAppController {

    private var cancellables = Set<AnyCancellable>()
    private var favouriteScenarios: AnyPublisher<[ScenarioId], Never>?

    init(
        targetAudience: Audience?,
        favouriteScenarios: AnyPublisher<[ScenarioId], Never>?,
        layout: ScenarioListLayout,
        select: @escaping (ScenarioId) -> Void
    ) {
        self.favouriteScenarios = favouriteScenarios
        super.init(targetAudience: targetAudience, select: select)

        setupBindings(select: select)
    }

    private func setupBindings(select: @escaping (ScenarioId) -> Void) {
        favouriteScenarios?
            .sink { [weak self] scenarioIds in
                guard let self = self else { return }
                self.sections = self.makeSections(select: select, favouriteScenarios: scenarioIds)
            }
            .store(in: &cancellables)
    }

}
