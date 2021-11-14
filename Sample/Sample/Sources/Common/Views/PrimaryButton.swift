//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

// TODO: Change to ButtonStyle
struct PrimaryButton: View {
    let imageName: String?
    let buttonText: Text
    let height: CGFloat
    
    var body: some View {
        HStack {
            if imageName != nil {
                Image(systemName: imageName!).foregroundColor(.white)
            }
            buttonText.foregroundColor(.white)
        }.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: .center)
            .background(Color.accentColor)
            .cornerRadius(5)
            .padding()
    }
}
