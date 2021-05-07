//
//  QuizPageViewController.swift
//  QuizApp
//
//  Created by five on 07/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class QuizPageViewController: UIPageViewController {
    
    var pages: [UIViewController]!
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    private var quiz: Quiz!
    
    private let colorBackgroundLight = UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1.00)
    private let colorBackgroundDark = UIColor(red: 0.15, green: 0.18, blue: 0.46, alpha: 1.00)
    
    init(quiz: Quiz) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.quiz = quiz
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load questions
        pages = [UIViewController]()
        for question in quiz.questions {
            let questionViewController = QuestionViewController(question: question)
            pages.append(questionViewController)
        }
        
        let pageAppearance = UIPageControl.appearance()
        pageAppearance.pageIndicatorTintColor = .clear
        
        dataSource = self
        
        self.setViewControllers([pages.first!], direction: .forward, animated: true, completion: nil)
    }
}

extension QuizPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex - 1 >= 0,
            currentIndex - 1 < pages.count
        else {
            return nil
        }
        
        let prevIndex = currentIndex - 1
        return pages[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex + 1 < pages.count
        else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        return pages[nextIndex]
    }
}
