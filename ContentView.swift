import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            WebViewContainer()
                .navigationBarTitle("WebView", displayMode: .inline)
        }
    }
}
