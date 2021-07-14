//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var accessToken: String = ""
    
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
                print("Should save")
            }) {
                Text("Save")
            }

            Spacer()
        }
    }
}
