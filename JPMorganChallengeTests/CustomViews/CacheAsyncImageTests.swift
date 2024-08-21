//
//  CacheAsyncImageTests.swift
//  JPMorganChallengeTests
//
//  Created by Abdul Raheem Beigh on 21/08/2024.
//

import XCTest
import SwiftUI
@testable import JPMorganChallenge

final class CacheAsyncImageTests: XCTestCase {
    
    @MainActor func testImageCaching() async {
        // Arrange
        let image = Image(systemName: "photo")
        let url = URL(string: "https://example.com/image.png")!
        let cacheAsyncImage = CacheAsyncImage(url: url) { phase in
            EmptyView()
        }
        
        // Act
        let result = cacheAsyncImage.storeImageInCache(image)
        
        // Assert
        XCTAssertTrue(result, "Image should be successfully cached.")
        
        let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url))
        XCTAssertNotNil(cachedResponse, "Cached response should not be nil.")
        XCTAssertEqual(cachedResponse?.data.count, cacheAsyncImage.imageToData(image)?.count, "Cached data should match the image data.")
    }
    
    @MainActor func testImageToDataConversion() {
        // Arrange
        let image = Image(systemName: "photo")
        let cacheAsyncImage = CacheAsyncImage(url: URL(string: "https://example.com/image.png")!) { phase in
            EmptyView()
        }
        
        // Act
        let data = cacheAsyncImage.imageToData(image)
        
        // Assert
        XCTAssertNotNil(data, "Image data should not be nil.")
    }
    
    @MainActor func testCacheAndRender_withSuccessPhase() {
        // Arrange
        let image = Image(systemName: "photo")
        let phase = AsyncImagePhase.success(image)
        let url = URL(string: "https://example.com/image.png")!
        let expectation = XCTestExpectation(description: "Image caching should be triggered on success phase.")
        
        let cacheAsyncImage = CacheAsyncImage(url: url) { phase in
            EmptyView()
        }
        
        // Act
        let _ = cacheAsyncImage.cacheAndRender(phase: phase)
        
        // Assert
        let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url))
        XCTAssertNotNil(cachedResponse, "Cached response should not be nil.")
        XCTAssertEqual(cachedResponse?.data.count, cacheAsyncImage.imageToData(image)?.count, "Cached data should match the image data.")
        expectation.fulfill()
    }
    
    func testCacheAndRender_withFailurePhase() {
        // Arrange
        let phase = AsyncImagePhase.failure(NSError(domain: "", code: -1, userInfo: nil))
        let cacheAsyncImage = CacheAsyncImage(url: URL(string: "https://example.com/image.png")!) { phase in
            Text("Failed to load image")
        }
        
        // Act
        let view = cacheAsyncImage.cacheAndRender(phase: phase)
        
        // Assert
        // Here we simply check if the view is returned correctly for the failure phase.
        XCTAssert(view is Text, "For failure phase, the content closure should be used.")
    }
    
}
