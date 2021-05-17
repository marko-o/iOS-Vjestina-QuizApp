//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by five on 07/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class QuizResultViewController: UIViewController {
    
    private var container: UIView!
    private var gradientLayer: CAGradientLayer!
    private var quizId: Int!
    private var correct: Int!
    private var total: Int!
    private var time: Double!
    private var resultLabel: UILabel!
    private var finishButton: UIButton!
    
    private var ns: NetworkService!
    
    private let colorBackgroundLight = UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1.00)
    private let colorBackgroundDark = UIColor(red: 0.15, green: 0.18, blue: 0.46, alpha: 1.00)
    private let colorButtonText = UIColor(red: 0.39, green: 0.16, blue: 0.87, alpha: 1.00)
    private let buttonFont = UIFont(name: "SourceSansPro-Bold", size: 16.0)
    
    init(quizId: Int, correct: Int, total: Int, time: Double) {
        self.quizId = quizId
        self.correct = correct
        self.total = total
        self.time = time
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
        
        
        container = UIView()
        view.addSubview(container)
        container.autoPinEdgesToSuperviewEdges()
        
        resultLabel = UILabel()
        container.addSubview(resultLabel)
        resultLabel.text = String(correct) + "/" + String(total)
        resultLabel.font = UIFont(name: "SourceSansPro-Bold", size: 88.0)
        resultLabel.textColor = .white
        resultLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        resultLabel.autoAlignAxis(.horizontal, toSameAxisOf: container, withOffset: -88)
        
        let attrFinishLabel = NSAttributedString(string: "Finish Quiz", attributes: [.foregroundColor: colorButtonText, .font: buttonFont!])
        finishButton = UIButton()
        container.addSubview(finishButton)
        finishButton.setAttributedTitle(attrFinishLabel, for: .normal)
        finishButton.backgroundColor = .white
        finishButton.layer.cornerRadius = 22
        finishButton.addTarget(self, action: #selector(self.finished(_:)), for: .touchUpInside)
        
        finishButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 40)
        finishButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 40)
        finishButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 44)
        finishButton.autoSetDimension(.height, toSize: 44)
        
        ns = NetworkService()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleResponse(response: QuizResultsUploadResponse?, err: RequestError?) -> Void {
        if err != nil {
            print(err)
        }
    }
    
    func uploadResults(token: String, results: QuizResults) {
        let url = URL(string: "https://iosquiz.herokuapp.com/api/result")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let quizJSON = try! JSONEncoder().encode(results)
        
        ns.executeQuizResultsUploadRequest(request, bodyData: quizJSON, completionHandler: self.handleResponse(response:err:))
    }
    
    @objc func finished(_: UIButton) {
        let defaults = UserDefaults.standard
        guard let credentialsEncoded = defaults.object(forKey: "credentials") as! Data? else {
            return
        }
        let credentials = try! JSONDecoder().decode(LoginCredentials.self, from: credentialsEncoded)
        
        let results = QuizResults(quizId: quizId, userId: credentials.id, time: time, noOfCorrect: correct)
        
        uploadResults(token: credentials.token, results: results)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
}
