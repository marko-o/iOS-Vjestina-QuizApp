//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by five on 07/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class SettingsViewController: UIViewController {
    
    private var container: UIView!
    private var gradientLayer: CAGradientLayer!
    private var usernameTitleLabel: UILabel!
    private var usernameLabel: UILabel!
    private var logoutButton: UIButton!
    
    private let colorBackgroundLight = UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1.00)
    private let colorBackgroundDark = UIColor(red: 0.15, green: 0.18, blue: 0.46, alpha: 1.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorBackgroundLight.cgColor, colorBackgroundDark.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.6, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        //addSublayer doesn't give good results
        view.layer.insertSublayer(gradientLayer, at: 0)
         
        buildViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        container = UIView()
        view.addSubview(container)
        
        usernameTitleLabel = UILabel()
        usernameTitleLabel.text = "USERNAME"
        container.addSubview(usernameTitleLabel)
        
        usernameLabel = UILabel()
        usernameLabel.text = "Marko Opačić"
        container.addSubview(usernameLabel)
        
        logoutButton = UIButton()
        logoutButton.addTarget(self, action: #selector(self.logout(_:)), for: .touchUpInside)
        container.addSubview(logoutButton)
    }
    
    private func styleViews() {
        usernameTitleLabel.textColor = .white
        usernameTitleLabel.font = UIFont(name: "SourceSansPro-SemiBold", size: 12.0)
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont(name: "SourceSansPro-Bold", size: 20.0)
        
        logoutButton.backgroundColor = .white
        let attrButtonString = NSAttributedString(string: "Log Out", attributes: [.foregroundColor: UIColor(red: 0.99, green: 0.40, blue: 0.40, alpha: 1.00), .font: UIFont(name: "SourceSansPro-Bold", size: 16.0)!])
        logoutButton.setAttributedTitle(attrButtonString, for: .normal)
        logoutButton.layer.cornerRadius = 22
    }
    
    private func defineLayoutForViews() {
        container.autoPinEdgesToSuperviewSafeArea()
        
        usernameTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        usernameTitleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        usernameTitleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        usernameTitleLabel.autoSetDimension(.height, toSize: 20)
        
        usernameLabel.autoPinEdge(.top, to: .bottom, of: usernameTitleLabel, withOffset: 4)
        usernameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        usernameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        logoutButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 32)
        logoutButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 32)
        logoutButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 32)
        logoutButton.autoSetDimension(.height, toSize: 44)
    }
    
    @objc func logout(_ button: UIButton) {
        let controllers = (self.navigationController?.viewControllers)!
        let loginVC = LoginViewController()
        var newControllers = [UIViewController]()
        newControllers.append(loginVC)
        newControllers.append(contentsOf: controllers)
        self.navigationController?.setViewControllers(newControllers, animated: false)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
