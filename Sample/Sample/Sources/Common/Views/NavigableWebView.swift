//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

struct NavigableWebView: View {
    
    @StateObject var webViewStore = WebViewStore()
    
    var title: String?
    var url: URL
    
    var body: some View {
        WebView(webView: webViewStore.webView)
            .navigationBarTitle(Text(verbatim: title ?? webViewStore.title ?? ""), displayMode: .inline)
            .navigationBarItems(
                trailing: HStack {
                    Button(action: goBack) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }.disabled(!webViewStore.canGoBack)
                    Button(action: goForward) {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }.disabled(!webViewStore.canGoForward)
                }
            )
            .onAppear {
                webViewStore.webView.load(URLRequest(url: url))
            }
    }
    
    func goBack() {
        webViewStore.webView.goBack()
    }
    
    func goForward() {
        webViewStore.webView.goForward()
    }
}
