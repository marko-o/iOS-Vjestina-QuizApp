//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 06/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    private var quiz: Quiz!
    private var question: Question!
    private var questions: [Question]!
    
    private var container: UIView!
    private var fieldContainer: UIView!
    private var gradientLayer: CAGradientLayer!
    
    private var titleLabel: UILabel!
    private var currentQuestionNumber: Int!
    private var correctlyAnswered: Int!
    private var questionNumberLabel: UILabel!
    private var questionTrackerView: QuestionTrackerView!
    private var questionLabel: UILabel!
    private var answerButtons: [UIButton]!
    
    // some commonly used values
    private let colorBackgroundLight = UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1.00)
    private let colorBackgroundDark = UIColor(red: 0.15, green: 0.18, blue: 0.46, alpha: 1.00)
    private let inputFieldLeftPadding = CGFloat(21)
    private let inputFieldRightPadding = CGFloat(-21)
    private let fieldSpacing = CGFloat(16.0)
    private let colorInputField = UIColor(white: 1.0, alpha: 0.3)
    private let colorButtonText = UIColor(red: 0.39, green: 0.16, blue: 0.87, alpha: 1.00)
    private let disabledButtonOpacity = CGFloat(0.60)
    
    private let colorUnanswered = UIColor(white: 1.0, alpha: 0.3)
    private let colorCurrent = UIColor(white: 1.0, alpha: 1.0)
    private let colorCorrect = UIColor(red: 0.44, green: 0.81, blue: 0.59, alpha: 1.00)
    private let colorIncorrect = UIColor(red: 0.99, green: 0.40, blue: 0.40, alpha: 1.00)
    
    init(quiz: Quiz) {
        self.quiz = quiz
        questions = quiz.questions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorBackgroundLight.cgColor, colorBackgroundDark.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.6, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        currentQuestionNumber = 0
        correctlyAnswered = 0
        
        buildViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
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
        titleLabel = UILabel()
        titleLabel.text = "QuizApp"
        questionNumberLabel = UILabel()
        questionLabel = UILabel()
        questionTrackerView = QuestionTrackerView(questions: quiz.questions.count)
        answerButtons = [UIButton(), UIButton(), UIButton(), UIButton()]
        
        view.addSubview(container)
        container.addSubview(questionNumberLabel)
        container.addSubview(questionTrackerView)
        container.addSubview(questionLabel)
        for button in answerButtons {
            button.addTarget(self, action: #selector(self.answered(button:)), for: .touchUpInside)
            container.addSubview(button)
        }
        
        navigationItem.titleView = titleLabel
        
        updateQuestion()
    }
    
    private func styleViews() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "SourceSansPro-Bold", size: 24.0)
        questionNumberLabel.textColor = .white
        questionNumberLabel.font = UIFont(name: "SourceSansPro-Bold", size: 18.0)
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
        container.translatesAutoresizingMaskIntoConstraints = false
        questionNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        questionTrackerView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var prevButton: UIButton! = nil
        for button in answerButtons {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
            if prevButton == nil {
                button.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: prevButton.bottomAnchor, constant: 16).isActive = true
            }
            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
            prevButton = button
        }
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            questionNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionNumberLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
            questionNumberLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            questionNumberLabel.heightAnchor.constraint(equalToConstant: 40),
            questionTrackerView.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 10),
            questionTrackerView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            questionTrackerView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            questionTrackerView.heightAnchor.constraint(equalToConstant: 7),
            questionLabel.topAnchor.constraint(equalTo: questionTrackerView.bottomAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 140),
            
        ])
    }
    
    @objc func answered(button: UIButton) {
        let qstate: QuestionState!
        if question.answers[question.correctAnswer] == button.titleLabel?.text {
            qstate = .correct
            correctlyAnswered = correctlyAnswered + 1
            button.backgroundColor = colorCorrect
        } else {
            qstate = .incorrect
            button.backgroundColor = colorIncorrect
            let correctButton = answerButtons[question.correctAnswer]
            correctButton.backgroundColor = colorCorrect
        }
        // update QuestionTrackerView for answered question
        let currIndex = self.quiz.questions.count - self.questions.count - 1
        self.questionTrackerView.setQuestionState(index: currIndex, state: qstate)
        
        //disable all the buttons until next question
        for b in answerButtons {
            b.isEnabled = false
        }
        
        // execute after the specified number of seconds
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // load next question
            self.updateQuestion()
            // set next question as current in the tracker
            self.questionTrackerView.setQuestionState(index: currIndex + 1, state: .current)
            // reload starting colors for answer buttons
            for b in self.answerButtons {
                b.backgroundColor = self.colorUnanswered
            }
            // enable all buttons again
            for b in self.answerButtons {
                b.isEnabled = true
            }
        }
    }
    
    private func updateQuestion() {
        if quiz == nil {
            return
        }
        
        if questions.isEmpty == true {
            //push QuizFinishView
            let qrvc = QuizResultViewController(correct: correctlyAnswered, total: quiz.questions.count)
            self.navigationController?.pushViewController(qrvc, animated: true)
        } else {
            question = questions.removeFirst()
            currentQuestionNumber = currentQuestionNumber + 1
        
            questionNumberLabel.text = String(currentQuestionNumber) + "/" + String(quiz.questions.count)
        
            //set question label and answer buttons
            questionLabel.text = question.question
            for (button, answerString) in zip(answerButtons, question.answers)  {
                let attrAnswerString = NSAttributedString(string: answerString, attributes: [.foregroundColor: UIColor.white, .font: UIFont(name: "SourceSansPro-Bold", size: 20.0)!])
                button.setAttributedTitle(attrAnswerString, for: .normal)
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 0)
            }
        }
    }
}
