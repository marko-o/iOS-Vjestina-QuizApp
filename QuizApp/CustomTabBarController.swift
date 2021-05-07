//
//  CustomTabBarController.swift
//  QuizApp
//
//  Created by five on 07/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    private let barItemIconColorNormal = UIColor(red: 0.70, green: 0.71, blue: 0.75, alpha: 1.00)
    private let barItemIconColorSelected = UIColor(red: 0.31, green: 0.25, blue: 0.55, alpha: 1.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quizzesViewController = QuizzesViewController()
        let quizzesIcon = UIImage(named: "round_timer_black_18pt")
        quizzesViewController.tabBarItem = UITabBarItem(title: "Quizzes", image: quizzesIcon?.withTintColor(barItemIconColorNormal), selectedImage: quizzesIcon?.withTintColor(barItemIconColorSelected))
        let settingsViewController = SettingsViewController()
        let settingsIcon = UIImage(named: "round_settings_black_18pt")
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: settingsIcon?.withTintColor(barItemIconColorNormal), selectedImage: settingsIcon?.withTintColor(barItemIconColorSelected))
        
        // styles for the tab bar
        UITabBar.appearance().barTintColor = .white
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00), NSAttributedString.Key.font:  UIFont(name: "SourceSansPro-Regular", size: 12.0)]
        UITabBarItem.appearance().setTitleTextAttributes(normalFontAttributes as [NSAttributedString.Key : Any], for: .normal)
        let selectedFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00), NSAttributedString.Key.font:  UIFont(name: "SourceSansPro-Regular", size: 12.0)]
        UITabBarItem.appearance().setTitleTextAttributes(selectedFontAttributes as [NSAttributedString.Key : Any], for: .selected)
        self.viewControllers = [quizzesViewController, settingsViewController]
    }
}
