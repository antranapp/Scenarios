//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
        
    private var dataSource: UICollectionViewDiffableDataSource<ListSection, ListRow>!
    private var collectionView: UICollectionView!
    
    private let sections: [ListSection]
    
    private var searchController: UISearchController!

    init(
        title: String,
        sections: [ListSection]
    ) {
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = title
        
        prepreSearchController()
        
        configureCollectionView()
        configureDataSource()
        configureDelegate()
        
        loadData(sections: sections)
        
        let menuButton = UIBarButtonItem(
            title: "Menu",
            image: UIImage(systemName: "ellipsis.circle"),
            primaryAction: nil,
            menu: createMenu()
        )
        navigationItem.rightBarButtonItem = menuButton
    }
    
    @objc private func didSwitchLayout() {
        NotificationCenter.default.post(name: .switchLayout, object: nil)
    }
    
    private func prepreSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Scenarios"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func createMenu() -> UIMenu {
        let action1 = UIAction(title: "Item 1", image: UIImage(systemName: "1.circle")) { _ in
            print("Item 1 selected")
        }
        
        let action2 = UIAction(title: "Item 2", image: UIImage(systemName: "2.circle")) { _ in
            print("Item 2 selected")
        }
        
        return UIMenu(title: "", children: [action1, action2])
    }

}

extension CollectionViewController {

    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .grouped)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        item.action()
    }
}

extension CollectionViewController {
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListRow> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            cell.accessories = [.outlineDisclosure()]
        }
        
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListRow> { cell, _, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .cell)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListRow> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            
            content.text = item.title
            content.secondaryText = item.description

            cell.contentConfiguration = content
            
            let action = UIAction(
                image: UIImage(systemName: "info.circle"),
                handler: { _ in
                    item.infoAction?()
                }
            )
            
            let infoButton = UIButton(primaryAction: action)
            let infoView = UICellAccessory.CustomViewConfiguration(
                customView: infoButton,
                placement: .trailing(
                    displayed: .always,
                    at: { _ in
                        0
                    }
                )
            )
            cell.accessories = (item.infoAction == nil) ? [] : [.customView(configuration: infoView)]
        }
        
        dataSource = UICollectionViewDiffableDataSource<ListSection, ListRow>(collectionView: collectionView) {
            // swiftlint:disable:next closure_parameter_position
            (collectionView: UICollectionView, indexPath: IndexPath, item: ListRow) -> UICollectionViewCell? in
                if indexPath.item == 0 {
                    return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
                } else {
                    if item.subRows.isEmpty {
                        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
                    } else {
                        return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
                    }
                }
        }
    }
    
    private func configureDelegate() {
        collectionView.delegate = self
    }
    
    private func loadData(sections: [ListSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, ListRow>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListRow>()
            let headerItem = ListRow(scenarioId: nil, title: section.title, action: {})
            sectionSnapshot.append([headerItem])
            sectionSnapshot.add(rows: section.rows, to: headerItem)
            sectionSnapshot.expand([headerItem])
            dataSource.apply(sectionSnapshot, to: section)
        }
    }
}

extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        if searchText.isEmpty {
            loadData(sections: sections)
        } else {
            filterRows(searchText)
        }
    }
    
    func filterRows(_ searchText: String) {
        let sectionRows = sections
            .map(\.rows)
            .flatMap { $0 }
        
        let filteredRows = sectionRows
            .flatten()
            .filter { $0.title.contains(searchText) }
        
        loadData(sections: [ListSection(title: "Results", rows: filteredRows)])
    }
    
    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
}

extension NSDiffableDataSourceSectionSnapshot {
    mutating func add(rows: [ItemIdentifierType], to root: ItemIdentifierType) where ItemIdentifierType == ListRow {
        append(rows, to: root)
        for row in rows {
            add(rows: row.subRows, to: row)
        }
    }
}

private extension Array where Element == ListRow {
    func flatten() -> [Element] {
        var result = [Element]()
            
        for element in self {
            if element.subRows.isEmpty {
                result.append(element)
            } else {
                result.append(contentsOf: element.subRows.flatten())
            }
        }
        
        return result
    }
}
