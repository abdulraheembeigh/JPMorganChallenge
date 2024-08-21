//
//  APODModel.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 18/08/2024.
//

import Foundation
struct APODModel: Codable {
    let date: String
    let explanation: String
    let title: String
    let url: String
    let mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case date, explanation, title, url
        case mediaType = "media_type"
    }
}
