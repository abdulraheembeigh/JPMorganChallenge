//
//  CacheAsyncImage.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 20/08/2024.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
            
            self.url = url
            self.scale = scale
            self.transaction = transaction
            self.content = content
        }
    
    var body: some View {
        AsyncImage(
            url: url,
            scale: scale,
            transaction: transaction
        ) { phase in
            cacheAndRender(phase: phase)
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            Task {
                await storeImageInCache(image)
            }
        }
        return content(phase)
    }
    
    @MainActor func storeImageInCache(_ image: Image) -> Bool {
        guard let data = imageToData(image) else { return false }
        
        let cachedResponse = CachedURLResponse(
            response: URLResponse(url: url, mimeType: "image/png", expectedContentLength: data.count, textEncodingName: nil),
            data: data
        )
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
        return true
    }
    
    @MainActor func imageToData(_ image: Image) -> Data? {
        let renderer = ImageRenderer(content: image)
        return renderer.uiImage?.pngData()
    }
}
