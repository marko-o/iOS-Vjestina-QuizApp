//
//  QuizResultsUploadResponse.swift
//  QuizApp
//
//  Created by five on 16/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

struct QuizResultsUploadResponse: Codable {
    let response: ServerResponse?
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}
