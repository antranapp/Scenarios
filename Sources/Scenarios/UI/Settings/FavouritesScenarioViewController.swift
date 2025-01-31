//
//  File.swift
//  
//
//  Created by Tran Binh An on 31/1/25.
//

import Foundation
import SwiftUI
import UIKit

struct FavouritesScenariosView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
            }
            .padding()

            Text("Hello World")
                .font(.largeTitle)
                .padding()
        }
    }
}

class FavouritesScenariosViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainView = FavouritesScenariosView()
        let hostingController = UIHostingController(rootView: mainView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}
