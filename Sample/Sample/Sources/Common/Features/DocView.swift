//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct DocView: View {
    var url: URL
    
    var body: some View {
        NavigationView {
            NavigableWebView(url: url)
        }
    }
}
