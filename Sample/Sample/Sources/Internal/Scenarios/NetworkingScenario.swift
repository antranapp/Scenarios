//
// Copyright © 2021 An Tran. All rights reserved.
//

import CodeViewer
import Foundation
import Scenarios
import SwiftUI

final class NetworkingScenario: Scenario {
    static var name: String = "Networking"
    static var kind: ScenarioKind = .networking
    
    static var rootViewProvider: RootViewProviding {
        NavigationAppController(withResetButton: true) { _ in
            UIHostingController(rootView: ContentView())
        }
    }
}

private struct ContentView: View {
    
    final class ViewModel: ObservableObject {
        @Published var response: String?
        @Published var error: String?
        @Published var keyword: String = "language:swift+sort:stars"

        private let service: GithubService

        init() {
            let client = NetworkClient()
            service = GithubService(client: client)
        }
        
        func load() {

            response = nil
            error = nil

            guard let url = GithubURLMaker.fetchRepositoryURL(for: keyword, page: 1) else {
                self.error = "Invalid request"
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
        VStack(spacing: 0) {
            TextField("Keyword", text: $viewModel.keyword)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top)

            PrimaryButton(
                imageName: nil,
                buttonText: Text("Send request"),
                height: 45
            )
            .onTapGesture {
                viewModel.load()
            }

            if let response = viewModel.response {
                CodeViewer(
                    content: .constant(response),
                    mode: .json,
                    darkTheme: .solarized_dark,
                    lightTheme: .solarized_light,
                    fontSize: 40
                )
            }

            if let error = viewModel.error {
                Text(error)
                    .fixedSize(horizontal: true, vertical: false)
            }

            Spacer()
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
