//
//  EndpointTests.swift
//  JPMorganChallengeTests
//
//  Created by Abdul Raheem Beigh on 21/08/2024.
//

import XCTest
@testable import JPMorganChallenge

final class EndpointTests: XCTestCase {
    
    func testEndpointURLRequest() {
        // Arrange
        let mockEndpoint = MockEndpoint()
        
        // Act
        let urlRequest = mockEndpoint.urlRequest
        
        // Assert
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://example.com/api/users?date=2024-08-21")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer access_token")
    }
}

struct MockEndpoint: Endpoint {
    var baseURLString: String {
        return "https://example.com"
    }
    
    var path: String {
        return "/api/users"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer access_token"
        ]
    }
    
    var parameters: [String: String]? {
        return [
            "date": "2024-08-21"
        ]
    }
}
