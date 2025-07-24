import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    @State static var webView = WKWebView()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefresh), for: .valueChanged)

        let scrollView = Self.webView.scrollView
        scrollView.refreshControl = refreshControl

        Self.webView.navigationDelegate = context.coordinator
        loadURL()

        let container = UIView()
        container.addSubview(Self.webView)
        Self.webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            Self.webView.topAnchor.constraint(equalTo: container.topAnchor),
            Self.webView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            Self.webView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            Self.webView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func loadURL() {
        if let url = URL(string: "https://arvinesmailian.ir") {
            let request = URLRequest(url: url)
            Self.webView.load(request)
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewContainer

        init(_ parent: WebViewContainer) {
            self.parent = parent
        }

        @objc func handleRefresh(refreshControl: UIRefreshControl) {
            WebViewContainer.webView.reload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                refreshControl.endRefreshing()
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            loadOfflinePage()
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            loadOfflinePage()
        }

        func loadOfflinePage() {
            if let filePath = Bundle.main.path(forResource: "Offline", ofType: "html") {
                let html = try? String(contentsOfFile: filePath, encoding: .utf8)
                WebViewContainer.webView.loadHTMLString(html ?? "<h1>Offline</h1>", baseURL: nil)
            }
        }
    }
}
