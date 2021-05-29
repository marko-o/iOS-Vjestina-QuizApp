//
//  ServerResponse.swift
//  QuizApp
//
//  Created by five on 16/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

enum ServerResponse {
    case unauthorized
    case forbidden
    case notFound
    case badRequest
    case ok
    case unknownResponse(statusCode: Int)
}
