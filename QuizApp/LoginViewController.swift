//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 09/04/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import Network

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private var container: UIView!
    private var fieldContainer: UIView!
    private var gradientLayer: CAGradientLayer!
    
    private var titleLabel: UILabel!
    private var emailField: UITextField!
    private var emailFieldContainer: UIView!
    private var passwordField: UITextField!
    private var passwordFieldContainer: UIView!
    private var togglePasswordButton: UIButton!
    private var submitButton: UIButton!
    private var errorLabel: UILabel!
    
    private var monitor: NWPathMonitor!
    private var ns: NetworkServiceProtocol!
    
    private var email: String!
    private var password: String!
    
    // some commonly used values
    private let colorBackgroundLight = UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1.00)
    private let colorBackgroundDark = UIColor(red: 0.15, green: 0.18, blue: 0.46, alpha: 1.00)
    private let colorInputField = UIColor(white: 1.0, alpha: 0.3)
    private let colorButtonText = UIColor(red: 0.39, green: 0.16, blue: 0.87, alpha: 1.00)
    private let disabledButtonOpacity = CGFloat(0.60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorBackgroundLight.cgColor, colorBackgroundDark.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.6, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        //addSublayer doesn't give good results
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        //set only arrow as back button
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         
         //set back button color
         self.navigationController?.navigationBar.tintColor = .white
         // set light status bar contents
         self.navigationController?.navigationBar.barStyle = .black
        
        //set transparent navbar
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true
        
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self]
            path in
            if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    self?.errorLabel.text = "Network currently unavailable"
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorLabel.text = ""
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        ns = NetworkService()
        email = ""
        password = ""
         
        buildViews()
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
        
        togglePasswordButton = UIButton(type: .custom)
        togglePasswordButton.setImage(UIImage(named: "round_visibility_white_18pt"), for: .normal)
        togglePasswordButton.addTarget(self, action: #selector(self.togglePasswordVisibility(_:)), for: .touchUpInside)
        // hidden until password field is not empty
        togglePasswordButton.isHidden = true
        passwordField.rightView = togglePasswordButton
        // this is set to always, then we manually adjust the toggle button to hidden if field is empty
        passwordField.rightViewMode = .always
        
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
        emailField.font = UIFont(name: "SourceSansPro-SemiBold", size: 16.0)
        let placeholderFont = UIFont(name: "SourceSansPro-Regular", size: 16.0)
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: placeholderFont!] )
        emailField.borderStyle = .none
        emailFieldContainer.layer.cornerRadius = 22
        emailFieldContainer.backgroundColor = colorInputField
        
        passwordField.backgroundColor = UIColor(white: 0, alpha: 0)
        passwordField.textColor = .white
        passwordField.font = UIFont(name: "SourceSansPro-Regular", size: 16)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
        passwordField.borderStyle = .none
        
        passwordFieldContainer.layer.cornerRadius = 22
        passwordFieldContainer.backgroundColor = colorInputField
        
        submitButton.backgroundColor = .white
        submitButton.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 16)
        submitButton.alpha = disabledButtonOpacity
        submitButton.setTitleColor(colorButtonText, for: .normal)
        submitButton.layer.cornerRadius = 22
        
        errorLabel.textColor = .white
        errorLabel.font = UIFont(name: "SourceSansPro-SemiBold", size: 16)
    }
    
    private func defineLayoutForViews() {
        container.autoSetDimension(.height, toSize: 370)
        container.autoPinEdge(toSuperviewEdge: .top, withInset: 79)
        container.autoPinEdge(toSuperviewEdge: .leading)
        container.autoPinEdge(toSuperviewEdge: .trailing)

        fieldContainer.autoSetDimension(.height, toSize: 300)
        fieldContainer.autoPinEdge(toSuperviewEdge: .leading)
        fieldContainer.autoPinEdge(toSuperviewEdge: .trailing)
        fieldContainer.autoPinEdge(toSuperviewEdge: .bottom)

        emailField.autoPinEdge(toSuperviewEdge: .top)
        emailField.autoPinEdge(toSuperviewEdge: .bottom)
        emailField.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        emailField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 21)

        emailFieldContainer.autoPinEdge(toSuperviewEdge: .leading, withInset: 30)
        emailFieldContainer.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        emailFieldContainer.autoPinEdge(.bottom, to: .top, of: passwordFieldContainer, withOffset: -16)
        emailFieldContainer.autoSetDimension(.height, toSize: 44)

        passwordField.autoPinEdge(toSuperviewEdge: .top)
        passwordField.autoPinEdge(toSuperviewEdge: .bottom)
        passwordField.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        passwordField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 21)

        passwordFieldContainer.autoPinEdge(toSuperviewEdge: .leading, withInset: 30)
        passwordFieldContainer.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        passwordFieldContainer.autoPinEdge(.bottom, to: .top, of: submitButton, withOffset: -16)
        passwordFieldContainer.autoSetDimension(.height, toSize: 44)

        submitButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 30)
        submitButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        submitButton.autoPinEdge(.bottom, to: .bottom, of: fieldContainer, withOffset: -40)
        submitButton.autoSetDimension(.height, toSize: 44)

        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(toSuperviewEdge: .top)

        errorLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        errorLabel.autoPinEdge(toSuperviewEdge: .bottom)
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
        
        // show/hide password visibility toggle
        if password.isEmpty {
            togglePasswordButton.isHidden = true
        } else {
            togglePasswordButton.isHidden = false
        }
        
        // enable/disable login button
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
    
    //Toggle password visibility button target
    @objc func togglePasswordVisibility(_: UIButton) {
        passwordField.togglePasswordVisibility()
        
        //change the toggle icon
        if passwordField.isSecureTextEntry {
            togglePasswordButton.setImage(UIImage(named: "round_visibility_white_18pt"), for: .normal)
        } else {
            togglePasswordButton.setImage(UIImage(named: "round_visibility_off_white_18pt"), for: .normal)
        }
    }
    
    func handleResponse(credentials: LoginCredentials?, err: RequestError?) -> Void {
        guard err == nil else {
            //handle error
            self.errorLabel.text = "Incorrect username and/or password"
            return
        }
    
        //login was successful
        let defaults = UserDefaults.standard
        let credentialsEncoded = try? JSONEncoder().encode(credentials)
        defaults.set(credentialsEncoded, forKey: "credentials")
    
        self.loadTabBarController()
    }
    
    //Login button target
    @objc func submit(_: UIButton) {
        submitButton.isEnabled = false
        
        email = email.trimmingCharacters(in: CharacterSet.newlines)
        password = password.trimmingCharacters(in: CharacterSet.newlines)
        
        let loginJSON: [String: String] = [
            "username": email,
            "password": password
        ]
        let loginData = try! JSONSerialization.data(withJSONObject: loginJSON)
        ns.executeLoginRequest(bodyData: loginData, completionHandler: { [weak self]
            credentials, err in
            self?.handleResponse(credentials: credentials, err: err)
        })
    }
    
    private func loadTabBarController() {
        let tabBarController = CustomTabBarController()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setViewControllers([tabBarController], animated: true)
    }

}

extension UITextField {
    func togglePasswordVisibility() {
        self.isSecureTextEntry.toggle()
        
        if let existingText = self.text, isSecureTextEntry {
            text = nil
            insertText(existingText)
        }
    }
}
