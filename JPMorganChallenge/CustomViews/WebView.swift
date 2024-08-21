//
//  WebView.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 19/08/2024.
//

import SwiftUI
import WebKit

// Step 1: Create a WebView struct
struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}


#Preview {
    WebView(urlString: "https://www.google.com")
}
