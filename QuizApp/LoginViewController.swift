//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 09/04/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private var container: UIView!
    private var fieldContainer: UIView!
    private var gradientLayer: CAGradientLayer!
    
    private var titleLabel: UILabel!
    private var emailField: UITextField!
    private var emailFieldContainer: UIView!
    private var passwordField: UITextField!
    private var passwordFieldContainer: UIView!
    private var showPasswordButton: UIButton!
    private var submitButton: UIButton!
    private var errorLabel: UILabel!
    
    private var ds: DataService!
    
    private var email: String!
    private var password: String!
    
    // some commonly used values
    private let colorBackgroundLight = UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1.00)
    private let colorBackgroundDark = UIColor(red: 0.15, green: 0.18, blue: 0.46, alpha: 1.00)
    private let inputFieldCornerRadius = CGFloat(22)
    private let inputFieldHeight = CGFloat(44)
    private let inputFieldMaxWidth = CGFloat(400)
    private let inputFieldFontSize = CGFloat(16.0)
    private let inputFieldLeftPadding = CGFloat(21)
    private let inputFieldRightPadding = CGFloat(-21)
    private let fieldSpacing = CGFloat(16.0)
    private let colorInputField = UIColor(white: 1.0, alpha: 0.3)
    private let colorButtonText = UIColor(red: 0.39, green: 0.16, blue: 0.87, alpha: 1.00)
    private let disabledButtonOpacity = CGFloat(0.60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ds = DataService()
        email = ""
        password = ""
         
        buildViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorBackgroundLight.cgColor, colorBackgroundDark.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.6, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        //addSublayer doesn't give good results
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        container = UIView()
        view.addSubview(container)
        
        fieldContainer = UIView()
        container.addSubview(fieldContainer)
        
        titleLabel = UILabel()
        container.addSubview(titleLabel)
        titleLabel.text = "QuizApp"
        
        emailField = UITextField()
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = UITextAutocapitalizationType.none
        emailField.delegate = self

        emailFieldContainer = UIView()
        emailFieldContainer.addSubview(emailField)
        fieldContainer.addSubview(emailFieldContainer)
        
        passwordField = UITextField()
        passwordField.keyboardType = .default
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        
        passwordFieldContainer = UIView()
        passwordFieldContainer.addSubview(passwordField)
        fieldContainer.addSubview(passwordFieldContainer)
        
        submitButton = UIButton()
        submitButton.isEnabled = false
        submitButton.setTitle("Login", for: .normal)
        submitButton.isUserInteractionEnabled = true
        submitButton.addTarget(self, action: #selector(self.submit(_:)), for: .touchUpInside)
        fieldContainer.addSubview(submitButton)
        
        errorLabel = UILabel()
        errorLabel.text = ""
        fieldContainer.addSubview(errorLabel)
    }
    
    
    private func styleViews() {
        UITextField.appearance().tintColor = .white
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "SourceSansPro-Bold", size: 32.0)
        
        emailField.backgroundColor = UIColor(white: 0, alpha: 0)
        emailField.textColor = .white
        emailField.font = UIFont(name: "SourceSansPro-Regular", size: 16.0)
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
        emailField.borderStyle = .none
        emailFieldContainer.layer.cornerRadius = inputFieldCornerRadius
        emailFieldContainer.backgroundColor = colorInputField
        
        passwordField.backgroundColor = UIColor(white: 0, alpha: 0)
        passwordField.textColor = .white
        passwordField.font = UIFont(name: "SourceSansPro-Regular", size: inputFieldFontSize)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
        passwordField.borderStyle = .none
        passwordField.rightViewMode = .whileEditing
        passwordField.rightView = showPasswordButton
        passwordFieldContainer.layer.cornerRadius = inputFieldCornerRadius
        passwordFieldContainer.backgroundColor = colorInputField
        
        submitButton.backgroundColor = .white
        submitButton.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: inputFieldFontSize)
        submitButton.alpha = disabledButtonOpacity
        submitButton.setTitleColor(colorButtonText, for: .normal)
        submitButton.layer.cornerRadius = inputFieldCornerRadius
        
        errorLabel.textColor = .white
        errorLabel.font = UIFont(name: "SourceSansPro-SemiBold", size: inputFieldFontSize)
    }
    
    
    private func defineLayoutForViews() {
        container.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /* explicitly defined constraints so that priority could be set */
        
        let emailFieldContainerLeading = emailFieldContainer.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 30)
        let emailFieldContainerTrailing =
        emailFieldContainer.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -30)
        emailFieldContainerLeading.priority = UILayoutPriority(750)
        emailFieldContainerTrailing.priority = UILayoutPriority(750)
        
        let passwordFieldContainerLeading = passwordFieldContainer.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 30)
        let passwordFieldContainerTrailing = passwordFieldContainer.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -30)
        passwordFieldContainerLeading.priority = UILayoutPriority(750)
        passwordFieldContainerTrailing.priority = UILayoutPriority(750)
        
        let submitButtonLeading =
            submitButton.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 30)
        let submitButtonTrailing = submitButton.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -30)
        submitButtonLeading.priority = UILayoutPriority(750)
        submitButtonTrailing.priority = UILayoutPriority(750)
        
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: 79),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 370),
            
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            
            fieldContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            fieldContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            fieldContainer.heightAnchor.constraint(equalToConstant: 300),
            fieldContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -40),
            
            
            // email textfield within container
            emailField.leadingAnchor.constraint(equalTo: emailFieldContainer.leadingAnchor, constant: inputFieldLeftPadding),
            emailField.trailingAnchor.constraint(equalTo: emailFieldContainer.trailingAnchor, constant: inputFieldRightPadding),
            emailField.topAnchor.constraint(equalTo: emailFieldContainer.topAnchor),
            emailField.bottomAnchor.constraint(equalTo: emailFieldContainer.bottomAnchor),
            emailField.centerYAnchor.constraint(equalTo: emailFieldContainer.centerYAnchor),
           
            // constraints for email container
            emailFieldContainerLeading,
            emailFieldContainerTrailing,
            emailFieldContainer.widthAnchor.constraint(lessThanOrEqualToConstant: inputFieldMaxWidth),
            emailFieldContainer.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            emailFieldContainer.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor),
            emailFieldContainer.bottomAnchor.constraint(equalTo: passwordFieldContainer.topAnchor, constant: -fieldSpacing),
            
            
            // password textfield within container
            passwordField.leadingAnchor.constraint(equalTo: passwordFieldContainer.leadingAnchor, constant: inputFieldLeftPadding),
            passwordField.trailingAnchor.constraint(equalTo: passwordFieldContainer.trailingAnchor, constant: inputFieldRightPadding),
            passwordField.topAnchor.constraint(equalTo: passwordFieldContainer.topAnchor),
            passwordField.bottomAnchor.constraint(equalTo: passwordFieldContainer.bottomAnchor),
            passwordField.centerYAnchor.constraint(equalTo: passwordFieldContainer.centerYAnchor),
            
            // constraints for password container
            passwordFieldContainerLeading,
            passwordFieldContainerTrailing,
            passwordFieldContainer.widthAnchor.constraint(lessThanOrEqualToConstant: inputFieldMaxWidth),
            passwordFieldContainer.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            passwordFieldContainer.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor),
            passwordFieldContainer.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -fieldSpacing),
            
            
            submitButtonLeading,
            submitButtonTrailing,
            submitButton.widthAnchor.constraint(lessThanOrEqualToConstant: inputFieldMaxWidth),
            submitButton.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            submitButton.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: -fieldSpacing),
            
            errorLabel.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
    }
    
    
    /* TextFieldDelegate functions */
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var associatedContainer: UIView!
        if textField == emailField {
            associatedContainer = emailFieldContainer
        } else if textField == passwordField {
            associatedContainer = passwordFieldContainer
        }
        associatedContainer.layer.borderWidth = 1
        associatedContainer.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var associatedContainer: UIView!
        if textField == emailField {
            associatedContainer = emailFieldContainer
        } else if textField == passwordField {
            associatedContainer = passwordFieldContainer
        }
        associatedContainer.layer.borderWidth = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)

        errorLabel.text = ""
        
        if textField == emailField {
            email = updatedString!
        } else if textField == passwordField {
            password = updatedString!
        }
        
        if email.isEmpty || password.isEmpty {
            submitButton.isEnabled = false
            submitButton.alpha = disabledButtonOpacity
        } else {
            submitButton.isEnabled = true
            submitButton.alpha = 1.0
        }
        // always return true so that changes propagate
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func isValidEmail(string: String) -> Bool {
        //pattern validation code
        return true
    }
    
    //Submit button target
    @objc func submit(_: UIButton) {
        if isValidEmail(string: email) {
            var status: LoginStatus!
            status = ds.login(email: email, password: password)
            print("\n-------- Login information --------")
            switch status {
            case .success:
                print("SUCCESS")
            case .error(let errcode, let errmsg):
                errorLabel.text = "Incorrect username and/or password"
                print("ERROR (" + String(errcode) + "): " + errmsg)
            case .none:
                print("noinfo")
            }
            print("username: " + email)
            print("password: " + password)
            print("--------------- END ---------------")
        }
    }

}