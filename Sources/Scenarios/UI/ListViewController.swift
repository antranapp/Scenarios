//
// Copyright © 2021 An Tran. All rights reserved.
//

import UIKit

struct ListRow: Hashable {
    private var identifier = UUID()
    
    let id: String
    let title: String
    let description: String?
    let infoAction: (() -> Void)?
    let action: () -> Void
    
    let scenarioId: ScenarioId?
    
    var subRows: [ListRow]

    init(
        id: String = UUID().uuidString,
        scenarioId: ScenarioId?,
        title: String,
        description: String? = nil,
        infoAction: (() -> Void)? = nil,
        action: @escaping () -> Void,
        subRows: [ListRow] = []
    ) {
        self.id = id
        self.scenarioId = scenarioId
        self.title = title
        self.description = description
        self.infoAction = infoAction
        self.action = action
        self.subRows = subRows
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: ListRow, rhs: ListRow) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

struct ListSection: Hashable {
    
    var id: String
    var title: String
    var rows: [ListRow]
    
    init(id: String = UUID().uuidString, title: String, rows: [ListRow]) {
        self.id = id
        self.title = title
        self.rows = rows
    }
}

class ListViewController: UITableViewController {

    private let cellReuseId = UUID().uuidString
    
    private var searchController: UISearchController!

    private let sections: [ListSection]
    
    private var filteredRows = [ListRow]()

    init(title: String, sections: [ListSection]) {
        self.sections = sections
        super.init(style: .grouped)
        self.title = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        prepreSearchController()
        
        if #available(iOS 13.0, *) {
            let switchLayoutButton = UIBarButtonItem(
                image: UIImage(systemName: "list.bullet"),
                style: .plain,
                target: self,
                action: #selector(didSwitchLayout)
            )
            navigationItem.rightBarButtonItem = switchLayoutButton
        }
    }
    
    func scenarioId(at indexPath: IndexPath) -> ScenarioId? {
        return sections[indexPath.section].rows[indexPath.row].scenarioId
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRows.count
        }
        
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        
        let row = self.row(at: indexPath)
        
        cell.textLabel?.text = row.title
        
        cell.detailTextLabel?.text = row.description
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        
        if row.subRows.isEmpty {
            cell.accessoryType = (row.infoAction == nil) ? .none : .detailButton
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        row(at: indexPath).infoAction?()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRow = row(at: indexPath)
        if currentRow.subRows.isEmpty {
            row(at: indexPath).action()
        } else {
            let childSections = ListSection(title: currentRow.title, rows: currentRow.subRows)
            let childListViewController = ListViewController(title: currentRow.title, sections: [childSections])
            navigationController?.pushViewController(childListViewController, animated: true)
        }
    }
    
    private func row(at indexPath: IndexPath) -> ListRow {
        if isFiltering {
            return filteredRows[indexPath.row]
        } else {
            return sections[indexPath.section].rows[indexPath.row]
        }
    }
}

extension ListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filterRows(searchText)
    }
    
    func filterRows(_ searchText: String) {
        filteredRows = sections
            .flatMap(\.rows)
            .filter {
                $0.title.contains(searchText)
            }
        
        tableView.reloadData()
    }
    
    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
}

private final class DetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
