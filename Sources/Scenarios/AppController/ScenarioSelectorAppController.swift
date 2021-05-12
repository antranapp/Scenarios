//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import UIKit

class ScenarioSelectorAppController: RootViewProviding {
    
    enum State {
        case starting
        case ready
    }

    let rootViewController: UIViewController
    
    @Published private var state: State = .starting
    
    private var cancellable: AnyCancellable?
    private var sections = [ListSection]()
    
    private var plugins = [ScenarioPlugin]()
    private var layout: ScenarioListLayout
    private var targetAudience: Audience?
    
    // MARK: Initilizer
    
    init(
        targetAudience: Audience?,
        layout: ScenarioListLayout,
        select: @escaping (ScenarioId) -> Void
    ) {
        self.targetAudience = targetAudience
        self.layout = layout
        
        let navigationController = UINavigationController()
        rootViewController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true

        sections = makeSections(select: select)
        
        setupBindings()
    }
    
    // MARK: Private helpers
    
    private func setupBindings() {
        cancellable = $state.sink { [weak self] state in
            self?.updateContent(for: state)
        }
    }
    
    private func updateContent(for newState: State) {
        switch newState {
        case .starting:
            state = .ready
        case .ready:
            pushScenarioViewController()
        }
    }
    
    private func pushScenarioViewController() {
        let viewController: UIViewController
        switch layout {
        case .nestedList:
            viewController = ScenarioSeletorNestedListViewController(title: "Scenarios", sections: sections)
        case .outlineList:
            if #available(iOS 14, *) {
                viewController = ScenarioSeletorOutlineListViewController(title: "Scenarios", sections: sections)
            } else {
                viewController = ScenarioSeletorNestedListViewController(title: "Scenarios", sections: sections)
            }
        }
        (rootViewController as? UINavigationController)?.pushViewController(viewController, animated: false)
    }

    private func showInfo(_ info: ScenarioInfo) {
        var action: UIAlertAction?
        if let configure = info.configure {
            action = UIAlertAction(
                title: "Configure",
                style: .default,
                handler: { [weak rootViewController] _ in
                    guard let rootViewController = rootViewController else { return }
                    rootViewController.dismiss(animated: true) {
                        configure(rootViewController)
                    }

                }
            )
        }

        rootViewController.showAlert(
            title: info.name,
            message: info.description,
            preferredStyle: .actionSheet,
            action: action
        )
    }
    
    private func makeSections(select: @escaping (ScenarioId) -> Void) -> [ListSection] {
        let sections = ScenarioKind.allCases
            .sorted { $0.nameForSorting < $1.nameForSorting }
            .compactMap {
                ListSection(
                    targetAudience: targetAudience,
                    scenariosOfKind: $0,
                    select: select,
                    showInfo: { [weak self] info in self?.showInfo(info) }
                )
            }
            .filter { !$0.rows.isEmpty }
                
        let groupedSections = sections.map { section -> ListSection in
            var newRows = [ListRow]()
            // Merge category row
            for row in section.rows {
                if let categoryRowIndex = newRows.firstIndex(where: { $0.id == row.id }) { // found existing categories
                    // Try to merge sub-category rows as well
                    for subCategoryRow in row.subRows {
                        if let subCategoryRowIndex = newRows[categoryRowIndex].subRows.firstIndex(where: { $0.id == subCategoryRow.id }) { // found existing subCategory
                            newRows[categoryRowIndex].subRows[subCategoryRowIndex].subRows.append(contentsOf: subCategoryRow.subRows)
                        } else {
                            newRows[categoryRowIndex].subRows.append(subCategoryRow)
                        }
                    }
                } else {
                    newRows.append(row)
                }
            }
            
            return ListSection(id: section.id, title: section.title, rows: newRows)
        }
        return groupedSections
    }
}

class ScenarioSeletorNestedListViewController: ListViewController {}

@available(iOS 14, *)
class ScenarioSeletorOutlineListViewController: CollectionViewController {}

private extension ListSection {

    init?(
        targetAudience: Audience?,
        scenariosOfKind kind: ScenarioKind,
        select: @escaping (ScenarioId) -> Void,
        showInfo: @escaping (ScenarioInfo) -> Void
    ) {
        let rows = ScenarioId.allCases.lazy
            .filter { $0.scenarioType.kind == kind }
            .filter {
                ($0.scenarioType as? AudienceTargetable.Type)?.canDisplay(for: targetAudience) ?? true
            }
            .sorted { $0.scenarioType.nameForSorting < $1.scenarioType.nameForSorting }
            .map { id -> ListRow in
                ListRow(id: id, select: select, showInfo: showInfo)
            }
        
        guard !rows.isEmpty else {
            return nil
        }
        
        self.init(title: kind.name, rows: rows)
    }

}

private extension ListRow {
    init(
        id: ScenarioId,
        select: @escaping (ScenarioId) -> Void,
        showInfo: @escaping (ScenarioInfo) -> Void
    ) {
        let infoAction: (() -> Void)? = id.scenarioType.info.map { info in
            { showInfo(info) }
        }
        
        var currentRow = ListRow(
            title: id.scenarioType.name,
            description: id.scenarioType.shortDescription,
            infoAction: infoAction
        ) { select(id) }

        if let category = id.scenarioType.category {
            if let subCategory = id.scenarioType.subCategory {
                currentRow = ListRow(
                    id: subCategory.id,
                    title: subCategory.name,
                    action: {},
                    subRows: [currentRow]
                )
            }

            self.init(
                id: category.id,
                title: category.name,
                infoAction: nil,
                action: {},
                subRows: [currentRow]
            )
        } else {
            self.init(
                title: id.scenarioType.name,
                description: id.scenarioType.shortDescription,
                infoAction: infoAction
            ) { select(id) }
        }
    }
}
