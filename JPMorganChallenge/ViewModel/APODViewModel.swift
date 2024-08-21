//
//  APODViewModel.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 18/08/2024.
//

import Foundation
class APODViewModel: ObservableObject {
    
    @Published var apod: APODModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let environment: Environment
    private let apodService: APODServiceProtocol
    
    init(apodService: APODServiceProtocol, environment: Environment = .current) {
        self.apodService = apodService
        self.environment = environment
    }
    
    @MainActor
    func fetchAPODAsync(for date: Date = Date()) async {
        isLoading = true
        errorMessage = nil
        do {
            let parameters = getAPODParamenters(for: date)
            let fetchedAPOD = try await apodService.fetchAPOD(for: parameters)
            apod = fetchedAPOD
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func getAPODParamenters(for date: Date)-> [String: String]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        var parameters: [String: String] = setAPODEnvironmentParamenters()
        parameters["date"] = dateString
        return parameters
    }
    
    private func setAPODEnvironmentParamenters()-> [String: String]{
        var parameters: [String: String] = [:]
        switch environment {
        case .production:
            parameters["api_key"] = "DEMO_KEY"
        case .development:
            parameters["concept_tags"] = "False"
        }
        return parameters
    }
}
