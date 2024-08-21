//
//  APODServiceTests.swift
//  JPMorganChallengeTests
//
//  Created by Abdul Raheem Beigh on 21/08/2024.
//

import XCTest
@testable import JPMorganChallenge

final class APODServiceTests: XCTestCase {

    var apodService: APODService!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        apodService = APODService(networkService: mockNetworkService)
    }
    
    func testFetchAPOD_Success() async throws {
        // Arrange
        let mockAPOD = APODModel(date: "2023-08-20", explanation: "Test", title: "Test Title", url: "https://example.com", mediaType: "image")
        mockNetworkService.mockResult = .success(mockAPOD)
        
        // Act
        let result = try await apodService.fetchAPOD()
        
        // Assert
        XCTAssertEqual(result.title, mockAPOD.title)
    }
    
    func testFetchAPOD_Failure() async {
        // Arrange
        let mockError = NetworkError.httpError(404)
        mockNetworkService.mockResult = .failure(mockError)
        
        // Act
        do {
            // Attempt to fetch APOD, which should throw an error
            _ = try await apodService.fetchAPOD()
            
        // Assert
            XCTFail("Expected to throw, but no error was thrown")
        } catch {
            // Verify that the error is of type NetworkError.httpError
            if case NetworkError.httpError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected NetworkError.httpError, but got \(error)")
            }
        }
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var mockResult: Result<Decodable, Error>?
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let result = mockResult else {
            fatalError("Mock result not set")
        }
        switch result {
        case .success(let value):
            return value as! T
        case .failure(let error):
            throw error
        }
    }
}
