//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct RepositoryRowView: View {
    
    let repository: Repository
    
    var body: some View {
        
        HStack {
            RemoteImageContainer(imageUrl: repository.owner!.avatarImageUrl)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(repository.repoName)
                    .font(.headline)
                
                Text("\(String.localizedString(forKey: "txt_number_forks")) \(repository.numberOfForks ?? 0)")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                
                Text("\(String.localizedString(forKey: "txt_number_watchers")) \(repository.numberOfWatchers ?? 0)")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
        }
    }
}
