//
//  APODViewModelTests.swift
//  JPMorganChallengeTests
//
//  Created by Abdul Raheem Beigh on 20/08/2024.
//

import XCTest
@testable import JPMorganChallenge

final class APODViewModelTests: XCTestCase {
    var viewModel: APODViewModel!
    var mockAPODService: MockAPODService!
    
    override func setUp() {
        super.setUp()
        mockAPODService = MockAPODService()
        viewModel = APODViewModel(apodService: mockAPODService, environment: .development)
    }
    
    func testFetchAPOD_Success() async {
        // Arrange
        
        let mockAPOD = APODModel(date: "2023-08-20", explanation: "Test", title: "Test Title", url: "https://example.com", mediaType: "image")
        mockAPODService.mockResult = .success(mockAPOD)
        
        // Act
        await viewModel.fetchAPODAsync(for: Date())
        
        // Assert
        XCTAssertEqual(viewModel.apod?.title, mockAPOD.title)
        XCTAssertEqual(viewModel.apod?.date, mockAPOD.date)
        XCTAssertEqual(viewModel.apod?.explanation, mockAPOD.explanation)
        XCTAssertEqual(viewModel.apod?.url, mockAPOD.url)
        XCTAssertEqual(viewModel.apod?.mediaType, mockAPOD.mediaType)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchAPOD_Failure() async {
        // Arrange
        mockAPODService.mockResult = .failure(NetworkError.httpError(404))
        
        // Act
        await viewModel.fetchAPODAsync(for: Date())
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.apod)
    }
}

// Mock classes for testing
class MockAPODService: APODServiceProtocol {
    var mockResult: Result<APODModel, Error>?
    
    func fetchAPOD(for parameters: [String : String]) async throws -> APODModel {
        switch mockResult {
        case .success(let apod):
            return apod
        case .failure(let error):
            throw error
        case .none:
            fatalError("Result not set in MockAPODService")
        }
    }
}
