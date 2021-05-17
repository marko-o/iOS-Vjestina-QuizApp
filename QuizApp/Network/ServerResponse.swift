//
//  ServerResponse.swift
//  QuizApp
//
//  Created by five on 16/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

enum ServerResponse: String, Codable {
    case unauthorized = "401 UNAUTHORIZED"
    case forbidden = "403 FORBIDDEN"
    case notFound = "404 NOT FOUND"
    case badRequest = "400 BAD REQUEST"
    case ok = "200 OK"
}
