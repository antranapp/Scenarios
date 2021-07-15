//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct RepositoryDetailView: View {
    var repository: Repository
    
    private let heightButtons: CGFloat = 45
    
    var body: some View {
        VStack(spacing: 32) {
            RemoteImageContainer(url: repository.owner?.avatarImageUrl, width: 100, height: 100)
            
            Text(repository.repoName)
                .bold()
                .font(.title)
            
            VStack(spacing: 16) {
                if repository.repoDescription != nil {
                    Text(repository.repoDescription!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if repository.license?.name != nil {
                    HStack {
                        Text(String.localizedString(forKey: "txt_license"))
                        Text(repository.license!.name)
                    }
                }
            }
            
            NavigationLink(destination: NavigableWebView(title: repository.repoName, url: repository.htmlUrl)) {
                PrimaryButtonStyle(
                    imageName: nil,
                    buttonText: Text("btn_txt_open_github"),
                    height: 45
                )
            }
            
            Spacer()
        }
        .padding()
    }
}
