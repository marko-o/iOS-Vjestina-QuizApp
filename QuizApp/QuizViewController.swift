//
//  QuizifiedViewController.swift
//  QuizApp
//
//  Created by five on 07/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    private var quiz: Quiz!
    
    private var container: UIView!
    private var gradientLayer: CAGradientLayer!
    
    private var titleLabel: UILabel!
    private var currentQuestionNumber: Int!
    private var correctlyAnswered: Int!
    private var questionNumberLabel: UILabel!
    private var questionTrackerView: QuestionTrackerView!
    private var questionPageViewController: QuizPageViewController!
    
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
        questionTrackerView = QuestionTrackerView(questions: quiz.questions.count)
        questionPageViewController = QuizPageViewController(quiz: quiz)
        self.addChild(questionPageViewController)
        questionPageViewController.didMove(toParent: self)
        
        view.addSubview(container)
        container.addSubview(questionNumberLabel)
        container.addSubview(questionTrackerView)
        container.addSubview(questionPageViewController.view)
        
        navigationItem.titleView = titleLabel
        
        updateQuestionNumberLabel(index: 1)
    }
    
    private func styleViews() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "SourceSansPro-Bold", size: 24.0)
        questionNumberLabel.textColor = .white
        questionNumberLabel.font = UIFont(name: "SourceSansPro-Bold", size: 18.0)
    }
    
    private func defineLayoutForViews() {
        container.translatesAutoresizingMaskIntoConstraints = false
        questionNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        questionTrackerView.translatesAutoresizingMaskIntoConstraints = false
        questionPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
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
            questionPageViewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            questionPageViewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            questionPageViewController.view.topAnchor.constraint(equalTo: questionTrackerView.bottomAnchor, constant: 1),
            questionPageViewController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            
        ])
    }
    
    func updateQuestionTracker(state: QuestionState) {
        // disable user interaction until next question
        // questionPageViewController.view.isUserInteractionEnabled = false
        if state == .correct {
            correctlyAnswered = correctlyAnswered + 1
        }
        self.questionTrackerView.setQuestionState(index: currentQuestionNumber - 1, state: state)
        
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.goToNextQuestion()
            self.updateQuestionNumberLabel(index: self.currentQuestionNumber + 1)
        }
    }
    
    func updateQuestionNumberLabel(index: Int) {
        if index > quiz.questions.count {
            let qrvc = QuizResultViewController(correct: correctlyAnswered, total: quiz.questions.count)
            self.navigationController?.pushViewController(qrvc, animated: true)
        } else {
            currentQuestionNumber = index
            questionNumberLabel.text = String(currentQuestionNumber) + "/" + String(quiz.questions.count)
        }
    }
    
    func goToNextQuestion() {
        questionPageViewController.dataSource = questionPageViewController
       guard let currentViewController = questionPageViewController.viewControllers?.first else { return }
        guard let nextViewController = questionPageViewController.dataSource?.pageViewController( questionPageViewController, viewControllerAfter: currentViewController) else { return }
        questionPageViewController.setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
        questionPageViewController.dataSource = nil
    }

    func goToPreviousQuestion() {
       guard let currentViewController = questionPageViewController.viewControllers?.first else { return }
        guard let previousViewController = questionPageViewController.dataSource?.pageViewController( questionPageViewController, viewControllerBefore: currentViewController ) else { return }
        questionPageViewController.setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
    }
}
