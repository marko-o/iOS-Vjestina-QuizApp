//
//  QuizResults.swift
//  QuizApp
//
//  Created by five on 16/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

struct QuizResults: Codable {
    let quizId: Int
    let userId: Int
    let time: Double
    let noOfCorrect: Int
    
    enum CodingKeys: String, CodingKey {
        case quizId = "quiz_id"
        case userId = "user_id"
        case time
        case noOfCorrect = "no_of_correct"
    }
}
