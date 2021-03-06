//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

class BaseSectionManager {

    var sections = [ListSection]() {
        didSet {
            onDidSetSections(sections)
        }
    }

    var sectionsDidSet: (([ListSection]) -> Void)?

    private var layout: ScenarioListLayout = .nestedList
    private let targetAudience: Audience?

    // MARK: Initilizer
    
    init(targetAudience: Audience?, select: @escaping (ScenarioId) -> Void) {
        self.targetAudience = targetAudience
        
        sections = makeSections(select: select, favouriteScenarios: [])
    }
    
    
    func makeScenarioViewController(with sections: [ListSection]) -> UIViewController {
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
        return viewController
    }
    
    func showInfo(_ info: ScenarioInfo) {
        fatalError("need to be implemented")
    }
    
    func onDidSetSections(_ sections: [ListSection]) {
        fatalError("need to be implemented")
    }

    func makeSections(
        select: @escaping (ScenarioId) -> Void,
        favouriteScenarios: [ScenarioId]
    ) -> [ListSection] {
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

        var groupedSections = sections.map { section -> ListSection in
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

        // Insert the favourite section
        if let favouriteSection = makeFavouriteSection(select: select, favouriteScenarios: favouriteScenarios) {
            groupedSections.insert(favouriteSection, at: 0)
        }

        return groupedSections
    }

    // MARK: Private helpers

    private func makeFavouriteSection(
        select: @escaping (ScenarioId) -> Void,
        favouriteScenarios: [ScenarioId]
    ) -> ListSection? {
        guard !favouriteScenarios.isEmpty else {
            return nil
        }
        
        let rows = ScenarioId.allCases
            .filter { favouriteScenarios.contains($0) }
            .map {
                ListRow(
                    scenarioId: $0,
                    select: select,
                    showInfo: { [weak self] info in self?.showInfo(info) }
                )
            }
        
        guard !rows.isEmpty else {
            return nil
        }
        
        return ListSection(
            title: "⭐️ Favourites",
            rows: rows
        )
    }
}

final class ScenarioSeletorNestedListViewController: ListViewController {}

@available(iOS 14, *)
final class ScenarioSeletorOutlineListViewController: CollectionViewController {}

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
            .map {
                ListRow(
                    scenarioId: $0,
                    select: select,
                    showInfo: showInfo
                )
            }
        
        guard !rows.isEmpty else {
            return nil
        }
        
        self.init(title: kind.name, rows: rows)
    }

}

private extension ListRow {
    init(
        scenarioId: ScenarioId,
        select: @escaping (ScenarioId) -> Void,
        showInfo: @escaping (ScenarioInfo) -> Void
    ) {
        let infoAction: (() -> Void)? = scenarioId.scenarioType.info.map { info in
            { showInfo(info) }
        }
        
        var currentRow = ListRow( // The original scenario row
            scenarioId: scenarioId,
            title: scenarioId.scenarioType.name,
            description: scenarioId.scenarioType.shortDescription,
            infoAction: infoAction
        ) { select(scenarioId) }

        if let category = scenarioId.scenarioType.category {
            if let subCategory = scenarioId.scenarioType.subCategory {
                currentRow = ListRow( // The subcategory row
                    id: subCategory.id,
                    scenarioId: nil,
                    title: subCategory.name,
                    action: {},
                    subRows: [currentRow]
                )
            }

            self.init( // The category row
                id: category.id,
                scenarioId: nil,
                title: category.name,
                infoAction: nil,
                action: {},
                subRows: [currentRow]
            )
        } else {
            self = currentRow
        }
    }
}

@available(iOS 13.0, *)
extension ListViewController {
    
    private func toggleFavourite(_ scenarioId: ScenarioId, isPinning: Bool = true) {
        NotificationCenter.default.post(name: .toggleFavourite, object: scenarioId)
    }
    
    override func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let scenarioId = self.scenarioId(at: indexPath) else {
            return nil
        }
        
        let isPinning = indexPath.section != 0 // adding to favourites when users are not selecting row in Favourite section.
        let action = isPinning ? "Add to favourites" : "Remove from favourites"
        let icon = isPinning ? "star.fill" : "star"
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil,
            actionProvider: { suggestedActions in
                let pinAction =
                    UIAction(
                        title: NSLocalizedString(action, comment: ""),
                        image: UIImage(systemName: icon)
                    ) { action in
                        self.toggleFavourite(
                            scenarioId,
                            isPinning: isPinning
                        )
                    }
                return UIMenu(title: "Actions", children: [pinAction])
            }
        )
    }
}
