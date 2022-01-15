//
// Copyright © 2021 An Tran. All rights reserved.
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
                    guard !authKey.isEmpty else { return }
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
