//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    
    var backAction: () -> Void
    
    init(action: @escaping (() -> Void)) {
        backAction = action
    }
    
    var body: some View {
        Button(action: {
            self.backAction()
        }) {
            Image(systemName: "chevron.left")
                .font(Font.title.weight(.regular))
                .foregroundColor(Color.purple)
        }
    }
}
