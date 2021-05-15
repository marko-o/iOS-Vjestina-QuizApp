//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by five on 07/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class QuestionViewController: UIViewController {
    
    weak var delegate: QuestionDelegate?

    private var question: Question!
    private var questions: [Question]!
    
    private var container: UIView!
    private var fieldContainer: UIView!
    
    private var questionLabel: UILabel!
    private var answerButtons: [UIButton]!
    
    private let colorUnanswered = UIColor(white: 1.0, alpha: 0.3)
    private let colorCurrent = UIColor(white: 1.0, alpha: 1.0)
    private let colorCorrect = UIColor(red: 0.44, green: 0.81, blue: 0.59, alpha: 1.00)
    private let colorIncorrect = UIColor(red: 0.99, green: 0.40, blue: 0.40, alpha: 1.00)
    
    init(question: Question, questionDelegate: QuestionDelegate) {
        self.question = question
        self.delegate = questionDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
    }
    
    // unnecessary with navigation bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        container = UIView()
        questionLabel = UILabel()
        answerButtons = [UIButton(), UIButton(), UIButton(), UIButton()]
        
        view.addSubview(container)
        container.addSubview(questionLabel)
        for button in answerButtons {
            button.addTarget(self, action: #selector(self.answered(button:)), for: .touchUpInside)
            container.addSubview(button)
        }
        
        updateQuestionData()
    }
    
    private func styleViews() {
        questionLabel.textColor = .white
        questionLabel.font = UIFont(name: "SourceSansPro-Bold", size: 24.0)
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 2
        for button in answerButtons {
            button.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
            button.layer.cornerRadius = 28
        }
    }
    
    private func defineLayoutForViews() {
        container.autoPinEdgesToSuperviewEdges()
        questionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        questionLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        questionLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        questionLabel.autoSetDimension(.height, toSize: 140)
        
        var prevButton: UIButton! = nil
        for button in answerButtons {
            button.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
            button.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
            if prevButton == nil {
                button.autoPinEdge(.top, to: .bottom, of: questionLabel, withOffset: 20)
            } else {
                button.autoPinEdge(.top, to: .bottom, of: prevButton, withOffset: 16)
            }
            button.autoSetDimension(.height, toSize: 56)
            prevButton = button
        }
    }
    
    @objc func answered(button: UIButton) {
        let qstate: QuestionState!
        if question.answers[question.correctAnswer] == button.titleLabel?.text {
            qstate = .correct
            button.backgroundColor = colorCorrect
        } else {
            qstate = .incorrect
            button.backgroundColor = colorIncorrect
            let correctButton = answerButtons[question.correctAnswer]
            correctButton.backgroundColor = colorCorrect
        }
        
        //disable all the buttons
        for b in answerButtons {
            b.isEnabled = false
        }
        
        self.delegate?.questionWasAnswered(self, state: qstate)
    }
    
    private func updateQuestionData() {
        questionLabel.text = question.question
        for (button, answerString) in zip(answerButtons, question.answers)  {
            let attrAnswerString = NSAttributedString(string: answerString, attributes: [.foregroundColor: UIColor.white, .font: UIFont(name: "SourceSansPro-Bold", size: 20.0)!])
                button.setAttributedTitle(attrAnswerString, for: .normal)
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 0)
        }
    }
}
