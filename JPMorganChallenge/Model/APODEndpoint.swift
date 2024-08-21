//
//  APODEndpoint.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 18/08/2024.
//

import Foundation

struct APODEndpoint: Endpoint {
    let baseURLString: String
    let path: String
    let method: HTTPMethod = .get
    let headers: [String: String]? = nil
    var parameters: [String: String]?
    
    init(parameters: [String:String]? = nil, environment: Environment = .current) {
        self.baseURLString = environment.baseURLString
        self.path = environment.path
        self.parameters = parameters
    }
}
