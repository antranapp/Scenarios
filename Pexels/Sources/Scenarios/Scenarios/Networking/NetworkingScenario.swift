//
// Copyright © 2021 An Tran. All rights reserved.
//

import CodeViewer
import Combine
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
        @Published var keyword: String = "nature"

        private let service: PexelsImageService

        private var connection: AnyCancellable?

        init() {
            let client = NetworkClient()
            let authenticationService = AuthenticationService()
            service = PexelsImageService(client: client, authenticationService: authenticationService)
            authenticationService.login("563492ad6f917000010000014d518d4e04d146a488ae371110cd2f35")
        }

        func load() {

            response = nil
            error = nil

            connection?.cancel()
            connection = service.fetch().sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        DispatchQueue.main.async {
                            self?.error = error.localizedDescription
                        }
                    }
                },
                receiveValue: { [weak self] imagesModel in
                    DispatchQueue.main.async {
                        self?.response = imagesModel.prettyPrintedJSONString
                    }
                }
            )
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

            Button(
                action: {
                    viewModel.load()
                },
                label: {
                    Text("Fetch")
                        .padding()
                }
            )

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
                    .padding()
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
