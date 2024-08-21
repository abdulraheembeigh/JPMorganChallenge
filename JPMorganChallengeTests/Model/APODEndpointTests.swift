//
//  APODEndpointTests.swift
//  JPMorganChallengeTests
//
//  Created by Abdul Raheem Beigh on 21/08/2024.
//

import XCTest
@testable import JPMorganChallenge

final class APODEndpointTests: XCTestCase {
    
    func testAPODEndpointProductionEnvironment() {
        // Arrange
        let parameters: [String: String] = [
            "date": "2024-08-21"
        ]
        let endpoint = APODEndpoint(parameters: parameters, environment: .production)
        
        // Act
        let urlRequest = endpoint.urlRequest
        
        // Assert
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.nasa.gov/planetary/apod?date=2024-08-21")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }
    
    func testAPODEndpointDevelopmentEnvironment() {
        // Arrange
        let parameters: [String: String] = [
            "date": "2024-08-21"
        ]
        let endpoint = APODEndpoint(parameters: parameters, environment: .development)
        
        // Act
        let urlRequest = endpoint.urlRequest
        
        // Assert
        XCTAssertEqual(urlRequest.url?.absoluteString, "http://127.0.0.1:8000/v1/apod?date=2024-08-21")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }
}
