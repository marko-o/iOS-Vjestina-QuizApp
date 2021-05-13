//
//  QuestionTrackerView.swift
//  QuizApp
//
//  Created by five on 06/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class QuestionTrackerView: UIView {
    private var questions: Int!
    private var questionViews: [UIView]!
    private var stackView: UIStackView!
    
    private let colorUnanswered = UIColor(white: 1.0, alpha: 0.3)
    private let colorCurrent = UIColor(white: 1.0, alpha: 1.0)
    private let colorCorrect = UIColor(red: 0.44, green: 0.81, blue: 0.59, alpha: 1.00)
    private let colorIncorrect = UIColor(red: 0.99, green: 0.40, blue: 0.40, alpha: 1.00)
    
    init(questions: Int) {
        self.questions = questions
        super.init(frame: .zero)
        
        questionViews = [UIView]()
        for _ in 0..<questions {
            let v = UIView()
            v.backgroundColor = colorUnanswered
            questionViews.append(v)
        }
        if questionViews.isEmpty == false {
            questionViews[0].backgroundColor = colorCurrent
        }
        stackView = UIStackView(arrangedSubviews: questionViews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        for v in questionViews {
            v.heightAnchor.constraint(equalToConstant: 5).isActive = true
            v.layer.cornerRadius = 2.5
            v.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setQuestionState(index: Int, state: QuestionState) {
        if index >= questionViews.count {
            return
        }
        let color: UIColor!
        switch state {
        case .unanswered:
            color = colorUnanswered
        case .current:
            color = colorCurrent
        case .correct:
            color = colorCorrect
        case .incorrect:
            color = colorIncorrect
        }
        questionViews[index].backgroundColor = color
    }
    
}
