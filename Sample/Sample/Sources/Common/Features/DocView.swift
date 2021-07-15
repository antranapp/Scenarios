//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct DocView: View {
    var body: some View {
        NavigationView {
            NavigableWebView(url: URL(string: "https://antranapp.github.io/Scenarios/")!)
        }
    }
}
