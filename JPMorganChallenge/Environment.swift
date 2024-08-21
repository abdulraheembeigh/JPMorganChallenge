//
//  Environment.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 18/08/2024.
//

import Foundation
enum Environment {
    case development
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    var baseURLString: String {
        switch self {
        case .production:
            return "https://api.nasa.gov"
        case .development:
            return "http://127.0.0.1:8000"
        }
    }
    var path: String {
        switch self {
        case .production:
            return "/planetary/apod"
        case .development:
            return "/v1/apod"
        }
    }
}
