//
//  APODService.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 18/08/2024.
//

import Foundation
protocol APODServiceProtocol {
    func fetchAPOD(for parameters: [String: String]) async throws -> APODModel
}

class APODService: APODServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchAPOD(for parameters: [String: String] = [:]) async throws -> APODModel {
        let endpoint = APODEndpoint(parameters: parameters)
        return try await networkService.request(endpoint)
    }
}
