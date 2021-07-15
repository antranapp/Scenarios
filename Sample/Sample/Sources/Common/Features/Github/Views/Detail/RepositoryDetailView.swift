//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct RepositoryDetailView: View {
    @EnvironmentObject var webService: GithubService
    
    var repository: Repository
    
    private let heightButtons: CGFloat = 45
    private let leadingTrailingSpace: CGFloat = 25
        
    var body: some View {
        VStack {
            RemoteImageContainer(imageUrl: repository.owner?.avatarImageUrl, width: 100, height: 100).padding(.bottom).padding(.top)
            
            Text(repository.repoName)
                .bold()
                .font(.title)
                .padding(.init(top: 0, leading: leadingTrailingSpace, bottom: 0, trailing: leadingTrailingSpace))
            
            VStack(alignment: .leading) {
                if repository.repoDescription != nil {
                    Text(repository.repoDescription!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.init(top: 20, leading: leadingTrailingSpace, bottom: 0, trailing: leadingTrailingSpace))
                }
                
                if repository.license?.name != nil {
                    SimpleHStackForText(title: String.localizedString(forKey: "txt_license"), description: repository.license!.name, leadingTrailingSpace: leadingTrailingSpace).padding(.top)
                }
            }
            
            NavigationLink(destination: NavigableWebView(title: repository.repoName, url: repository.htmlUrl), label: {
                PrimaryButtonStyle(imageName: nil, buttonText: Text("btn_txt_open_github"), leadingTrailingSpace: leadingTrailingSpace, height: 45).padding(.top)
            })
            
            Spacer()
        }
    }
}
