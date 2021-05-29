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
    private var quizPageViewController: QuizPageViewController!
    private var quizPageViewControllerDelegate: QuizPageViewControllerDelegate!
    
    private var startTime: UInt64!
    
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
        startTime = DispatchTime.now().uptimeNanoseconds
        
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
        quizPageViewController = QuizPageViewController(quiz: quiz, questionDelegate: self)
        quizPageViewControllerDelegate = quizPageViewController
        self.addChild(quizPageViewController)
        quizPageViewController.didMove(toParent: self)
        
        view.addSubview(container)
        container.addSubview(questionNumberLabel)
        container.addSubview(questionTrackerView)
        container.addSubview(quizPageViewController.view)
        
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
        
        quizPageViewController.view.autoPinEdge(toSuperviewEdge: .leading)
        quizPageViewController.view.autoPinEdge(toSuperviewEdge: .trailing)
        quizPageViewController.view.autoPinEdge(.top, to: .bottom, of: questionTrackerView, withOffset: 1)
        quizPageViewController.view.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    func updateQuestionTracker(state: QuestionState) {
        if state == .correct {
            correctlyAnswered = correctlyAnswered + 1
        }
        self.questionTrackerView.setQuestionState(index: currentQuestionNumber - 1, state: state)
        
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.quizPageViewControllerDelegate.goToNextQuestion(self)
            self.updateQuestionNumberLabel(index: self.currentQuestionNumber + 1)
        }
    }
    
    func updateQuestionNumberLabel(index: Int) {
        if index > quiz.questions.count {
            let currentTime = DispatchTime.now().uptimeNanoseconds
            let totalElapsedTimeNanoseconds = currentTime - startTime
            let totalElapsedTimeSeconds: Double = Double(totalElapsedTimeNanoseconds / 1000000000).rounded(.down)
            print(totalElapsedTimeSeconds)
            let resultInfo = QuizResultInfo(quizId: quiz.id, correct: correctlyAnswered, total: quiz.questions.count, time: totalElapsedTimeSeconds)
            let qrvc = QuizResultViewController(result: resultInfo)
            self.navigationController?.pushViewController(qrvc, animated: true)
        } else {
            currentQuestionNumber = index
            questionNumberLabel.text = String(currentQuestionNumber) + "/" + String(quiz.questions.count)
        }
    }
}

extension QuizViewController: QuestionDelegate {
    func questionWasAnswered(_ caller: AnyObject, state: QuestionState) {
        updateQuestionTracker(state: state)
    }
}
