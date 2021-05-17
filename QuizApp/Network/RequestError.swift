//
//  RequestError.swift
//  QuizApp
//
//  Created by five on 16/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case decodingError
}
