//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var accessToken: String
    
    init() {
        if let accessToken = UserDefaults.standard.object(forKey: Constants.accessTokenKey) as? String {
            _accessToken = State(initialValue: accessToken)
        } else {
            _accessToken = State(initialValue: "")
        }
    }
    
    var body: some View {
        VStack {
            Text("title_github_login")
                .font(.title)
                .padding()
            
            Text("txt_login_to_github")
                .font(.subheadline)
                .padding()

            Button(action: {
                print("Should open Github")
            }) {
                Text("Open Github")
            }

            TextField("Access Token", text: $accessToken)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                print("Should save: \(accessToken)")
                UserDefaults.standard.setValue(accessToken, forKey: Constants.accessTokenKey)
                print("AccessToken saved successfully.")
            }) {
                Text("Save")
            }

            Spacer()
        }
    }
}
