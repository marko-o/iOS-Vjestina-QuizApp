//
//  LoginCredentials.swift
//  QuizApp
//
//  Created by five on 16/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

struct LoginCredentials: Codable {
    let token: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case id = "user_id"
    }
}
