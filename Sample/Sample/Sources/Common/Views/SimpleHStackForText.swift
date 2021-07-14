//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct SimpleHStackForText: View {
    
    var title: String
    var description: String
    var leadingTrailingSpace: CGFloat
    
    var body: some View {
        HStack {
            Text("\(title):")
                .bold()
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.init(top: 0, leading: leadingTrailingSpace, bottom: 0, trailing: 0))
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: leadingTrailingSpace))
        }.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }
}
