//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation
import UIKit

final class ScenarioSelectorAppController: BaseScenarioSelectorAppController {

    private var cancellables = Set<AnyCancellable>()
    private var favouriteScenarios: CurrentValueSubject<[ScenarioId], Never>?

    private lazy var customViewController: UIViewController? = {
        guard let favouriteScenarios else { return nil }
        return FavouritesScenariosViewController(scenarioIds: favouriteScenarios)
    }()

    init(
        targetAudience: Audience?,
        favouriteScenarios: CurrentValueSubject<[ScenarioId], Never>?,
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

    override func makeScenarioViewController(with sections: [ListSection]) -> UIViewController {
        return ScenarioSeletorNestedListViewController(
            title: "Scenarios",
            sections: sections,
            customViewController: customViewController
        )
    }
}
