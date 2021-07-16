//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation
import Scenarios
import SwiftUI

final class NetworkingScenario: Scenario {
    static var name: String = "Networking"
    static var kind: ScenarioKind = .component
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: ContentView())
        }
    }
}

private struct ContentView: View {
    
    class ViewModel: ObservableObject {
        @Published var response: String?
        @Published var error: String?
        
        func load() {
            let client = NetworkClient()
            let service = GithubService(client: client)

            guard let url = GithubURLMaker.fetchRepositoryURL(for: nil, page: 1) else {
                return
            }
            
            service.fetch(url: url) { [weak self] (result: Result<RepositoryList, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let items):
                        self?.response = items.prettyPrintedJSONString
                    case .failure(let error):
                        self?.error = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if let response = viewModel.response {
                        Text(response)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    
                    if let error = viewModel.error {
                        Text(error)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }

                    Spacer()
                }
                .padding()
            }
            
        }
        .navigationTitle("Networking")
        .onAppear {
            viewModel.load()
        }
    }
}

public extension Encodable {
    var prettyPrintedJSONString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8) ?? nil
    }
}
