//
//  NetWorkServiceTests.swift
//  JPMorganChallengeTests
//
//  Created by Abdul Raheem Beigh on 20/08/2024.
//

import XCTest
@testable import JPMorganChallenge

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        
        networkService = NetworkService(urlSession: mockSession)
    }

    override func tearDown() {
        networkService = nil
        mockSession = nil
        super.tearDown()
    }

    func testInvalidURLResponseThrowsUnknownError() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            // Return nil for both response and data to simulate an invalid response scenario
            return (nil, nil)
        }
        
        // Act
        do {
            let _: APODModel = try await networkService.request(MockEndpoint())
            
        // Assert
            XCTFail("Expected unknownError to be thrown")
        } catch NetworkError.unknownError(let error as NSError) {
            // Success: unknownError was thrown as expected
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    func testHTTPErrorThrowsHTTPError() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 404, httpVersion: nil, headerFields: nil)!
            let data = Data() // Empty data
            return (response, data)
        }
        
        // Act
        do {
            let _: APODModel = try await networkService.request(MockEndpoint())
            
        // Assert
            XCTFail("Expected httpError to be thrown")
        } catch NetworkError.httpError(let statusCode) {
            XCTAssertEqual(statusCode, 404) // Correct HTTP status code was thrown
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    func testDecodingErrorThrowsDecodingError() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = "invalid json".data(using: .utf8)!
            return (response, data)
        }
        
        // Act
        do {
            let _: APODModel = try await networkService.request(MockEndpoint())
            
        // Assert
            XCTFail("Expected decodingError to be thrown")
        } catch NetworkError.decodingError {
            // Success, decoding error was thrown as expected
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    func testSuccessfulResponseReturnsDecodedData() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 200, httpVersion: nil, headerFields: nil)!
            let mockModel = APODModel(date: "2023-08-20", explanation: "Test", title: "Test Title", url: "https://example.com", mediaType: "image")
            let data = try! JSONEncoder().encode(mockModel)
            return (response, data)
        }
        
        // Act
        do {
            let result: APODModel = try await networkService.request(MockEndpoint())
            
        // Assert
            XCTAssertEqual(result.date, "2023-08-20")
            XCTAssertEqual(result.explanation, "Test")
            XCTAssertEqual(result.title, "Test Title")
            XCTAssertEqual(result.url, "https://example.com")
            XCTAssertEqual(result.mediaType, "image")// Success, returned data matches expected data
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}
// Mock URLSession to simulate network responses

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse?, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("No handler set for MockURLProtocol")
        }

        do {
            let (response, data) = try handler(request)
            if let response = response, let data = data {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
            } else {
                client?.urlProtocol(self, didFailWithError: NSError(domain: "InvalidResponse", code: 0, userInfo: nil))
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // No action needed
    }
}

