//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    
    var errorText: String
    var multipleLines: Bool = false
    
    var body: some View {
        VStack {
            Text(self.errorText)
                .if(multipleLines, transform: { view in
                    view.lineLimit(nil)
                })
                .if(!multipleLines, transform: { view in
                    view.lineLimit(1)
                })
                .font(.headline)
                .padding()
                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.white)
                .background(Color.red)
                .animation(.easeIn)
        }
    }
}
