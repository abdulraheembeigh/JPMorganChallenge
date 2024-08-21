//
//  EndPoint.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 17/08/2024.
//

import Foundation
protocol Endpoint {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
}

extension Endpoint {
    var urlRequest: URLRequest {
        guard let baseURL = URL(string: baseURLString) else {
            preconditionFailure("Invalid URL")
        }
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else {
            preconditionFailure("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
