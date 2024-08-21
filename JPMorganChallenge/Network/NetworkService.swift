//
//  NetworkService.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 17/08/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case httpError(Int)
    case decodingError(Error)
    case unknownError(Error)
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
        //default initialition of 150 MB
        init(urlSession: URLSession = URLSession.shared, cacheCapacity: Int = 150 * 1024 * 1024) {
            let cache = URLCache.shared
            cache.memoryCapacity = cacheCapacity
            cache.diskCapacity = cacheCapacity
            
            let configuration = urlSession.configuration//URLSessionConfiguration.default
            configuration.urlCache = cache
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            self.urlSession = urlSession
        }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = endpoint.urlRequest
        request.cachePolicy = .returnCacheDataElseLoad
        guard let (data, response) = try? await urlSession.data(for: request) else {
                throw NetworkError.unknownError(NSError(domain: "InvalidResponse", code: 0))
            }
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.unknownError(NSError(domain: "InvalidResponse",code: 0))
        }
        guard 200...299 ~= httpResponse.statusCode else{
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch{
            throw NetworkError.decodingError(error)
        }
    }
}
