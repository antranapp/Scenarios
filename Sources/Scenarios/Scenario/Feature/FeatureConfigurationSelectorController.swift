//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import UIKit

public class FeatureConfigurationSelectorController<Configuration: Identifiable & CustomStringConvertible, Output>: RootViewProviding {
    
    public var rootViewController = UIViewController()
    
    private enum AppState: Equatable {
       
        case listing
        case selected(_ configuration: Configuration)
        case prepared(_ output: Output)
        case ready(_ viewController: UIViewController)
        
        static func == (
            lhs: FeatureConfigurationSelectorController<Configuration, Output>.AppState,
            rhs: FeatureConfigurationSelectorController<Configuration, Output>.AppState
        ) -> Bool {
            switch (lhs, rhs) {
            case (.listing, .listing):
                return true
            case (.selected, .selected):
                return true
            case (.prepared, .prepared):
                return true
            case (.ready, .ready):
                return true
            default:
                return false
            }
        }

    }
    
    private var context: FeatureContext<Configuration, Output>
    @Published private var state: AppState = .listing
    private var cancellables = Set<AnyCancellable>()
    
    private var content: UIViewController? {
        didSet {
            oldValue?.dismiss(animated: true, completion: nil)
            oldValue?.remove()
            if let content = content {
                rootViewController.addFilling(content)
                UIAccessibility.post(notification: .screenChanged, argument: nil)
            }
        }
    }
    
    public init(context: FeatureContext<Configuration, Output>) {
        self.context = context
        
        setupBindings()
    }
    
    private func setupBindings() {
        $state
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.update(for: $0)
            }
            .store(in: &cancellables)
    }
    
    private func update(for state: AppState) {
        guard let content = makeContent(for: state) else {
            return
        }
        
        self.content = content
    }
    
    private func makeContent(for state: AppState) -> UIViewController? {
        switch state {
        case .listing:
            return UIHostingController(
                rootView: ConfigurationSelectionView(
                    configurations: context.configurations,
                    callback: {
                        self.context.selectedConfiguration = $0
                        self.state = .selected($0)
                    }
                )
            )
            
        case .selected(let configuration):
            context.didSelect(configuration)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.rootViewController.showAlert(title: error.localizedDescription)
                            self?.state = .listing
                        default: break
                        }
                    },
                    receiveValue: { [weak self] in
                        self?.state = .prepared($0)
                    }
                )
                .store(in: &cancellables)
            
            return nil
            
        case .prepared(let output):
            context.didPrepare(output)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.rootViewController.showAlert(title: error.localizedDescription)
                            self?.state = .listing
                        default: break
                        }
                    },
                    receiveValue: { [weak self] in
                        self?.state = .ready($0)
                    }
                )
                .store(in: &cancellables)
            return nil
            
        case .ready(let viewController):
            return viewController
        }
    }
}

private struct ConfigurationSelectionView<Configuration: Identifiable & CustomStringConvertible>: View {
    var configurations: [Configuration]
    var callback: (Configuration) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(configurations) { configuration in
                    Button(configuration.description) {
                        callback(configuration)
                    }
                }
            }
            .navigationTitle("Select a configuration")
        }
    }
}
