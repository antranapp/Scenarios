//
//  File.swift
//  
//
//  Created by Tran Binh An on 31/1/25.
//

import Foundation
import SwiftUI
import UIKit
import MovableWindow
import Combine

class FavouritesScenariosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private var scenarioIds: CurrentValueSubject<[ScenarioId], Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(scenarioIds: CurrentValueSubject<[ScenarioId], Never>) {
        self.scenarioIds = scenarioIds
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        setupUI()
        setupBindings()
    }
    
    private func setupBindings() {
        scenarioIds
            .sink { [weak self] scenarioIds in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let closeImage = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let minimumImage = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let resetImage = UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)

        
        let titleLabel = UILabel()
        titleLabel.text = "Favourites"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .lightGray
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let closeButton = UIButton()
        closeButton.tintColor = .white
        closeButton.setImage(closeImage, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let clearButton = UIButton()
        clearButton.tintColor = .white
        clearButton.setImage(resetImage, for: .normal)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let minimumButton = UIButton()
        minimumButton.tintColor = .white
        minimumButton.contentMode = .scaleAspectFit
        minimumButton.setImage(minimumImage, for: .normal)
        minimumButton.addTarget(self, action: #selector(minimum), for: .touchUpInside)
        view.addSubview(minimumButton)
        minimumButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minimumButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3),
            minimumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            minimumButton.widthAnchor.constraint(equalToConstant: 20),
            minimumButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavouriteDetailTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            tableView.bottomAnchor.constraint(equalTo: minimumButton.topAnchor, constant: -15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }    
    
    override func loadView() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 280)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        self.view = view
    }

    @objc private func clear() {
        NotificationCenter.default.post(name: .resetScenario, object: nil)
    }

    @objc private func close() {
        self.view.window?.isHidden = true
    }
    
    @objc private func minimum() {
        if let window = self.view.window as? ScenariosMovableWindow {
            window.minimized = true
        }
    }
}

extension FavouritesScenariosViewController {

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenarioIds.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = scenarioIds.value[indexPath.row].scenarioType.name
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle row selection if needed
        let scenarioId = scenarioIds.value[indexPath.row]

        NotificationCenter.default.post(name: .selectScenario, object: scenarioId)

    }
}

private final class FavouriteDetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        textLabel?.textColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
