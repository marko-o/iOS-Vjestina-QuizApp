//
//  QuestionDelegate.swift
//  QuizApp
//
//  Created by five on 14/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation

protocol QuestionDelegate: AnyObject {
    func questionWasAnswered(_ caller: AnyObject, state: QuestionState)
}
