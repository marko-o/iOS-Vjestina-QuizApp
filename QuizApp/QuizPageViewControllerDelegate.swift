//
//  QuizPageViewControllerDelegate.swift
//  QuizApp
//
//  Created by five on 15/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

protocol QuizPageViewControllerDelegate {
    func goToNextQuestion(_ caller: AnyObject)
    func goToPreviousQuestion(_ caller: AnyObject)
}
