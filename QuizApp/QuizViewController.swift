//
//  QuizifiedViewController.swift
//  QuizApp
//
//  Created by five on 07/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

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
        container.autoPinEdgesToSuperviewSafeArea()
        
        questionNumberLabel.autoPinEdge(toSuperviewEdge: .top)
        questionNumberLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        questionNumberLabel.autoPinEdge(toSuperviewEdge: .trailing)
        questionNumberLabel.autoSetDimension(.height, toSize: 40)
        
        questionTrackerView.autoPinEdge(.top, to: .bottom, of: questionNumberLabel, withOffset: 10)
        questionTrackerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        questionTrackerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        questionTrackerView.autoSetDimension(.height, toSize: 7)
        
        questionPageViewController.view.autoPinEdge(toSuperviewEdge: .leading)
        questionPageViewController.view.autoPinEdge(toSuperviewEdge: .trailing)
        questionPageViewController.view.autoPinEdge(.top, to: .bottom, of: questionTrackerView, withOffset: 1)
        questionPageViewController.view.autoPinEdge(toSuperviewEdge: .bottom)
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
