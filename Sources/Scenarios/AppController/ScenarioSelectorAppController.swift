//
//  File.swift
//  
//
//  Created by An Tran on 31/7/21.
//

import Foundation
import Combine

@available(iOS 13.0, *)
class ScenarioSelectorAppController: BaseScenarioSelectorAppController {

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

