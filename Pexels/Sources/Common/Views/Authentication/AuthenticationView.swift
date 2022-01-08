//
//  AuthenticationView.swift
//  Pexels-Production
//
//  Created by An Tran on 10/1/22.
//

import SwiftUI

struct AuthenticationView: View {
    let authenticated: (String) -> Void
    
    @State var authKey: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Pexels API Key", text: $authKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    guard !authKey.isEmpty else { return}
                    authenticated(authKey)
                } label: {
                    Text("Login")
                }

            }
            .padding()
            .navigationTitle("Login")
        }
        
    }
}
