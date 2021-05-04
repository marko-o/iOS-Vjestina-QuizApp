//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by five on 10/04/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class QuizzesViewController: UIViewController {
    
    private var container: UIView!
    private var quizlistContainer: UIView!
    private var quizlistCollectionView: UICollectionView!
    private var gradientLayer: CAGradientLayer!
    
    private var ds: DataService!
    
    private var titleLabel: UILabel!
    private var getQuizButton: UIButton!
    private var funFactImageView: UIImageView!
    private var funFactLabel: UILabel!
    private var funFactBody: UILabel!
    
    private var quizlist: [Quiz]!
    private var quizlistByCategory: [[Quiz]]!
    
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
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorBackgroundLight.cgColor, colorBackgroundDark.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.6, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        ds = DataService()
        quizlist = [Quiz]()
        quizlistByCategory = [[Quiz](), [Quiz]()]
        buildViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        container = UIView()
        view.addSubview(container)
        
        quizlistContainer = UIView()
        quizlistContainer.isHidden = true
        container.addSubview(quizlistContainer)
        
        titleLabel = UILabel()
        titleLabel.text = "QuizApp"
        container.addSubview(titleLabel)
        
        getQuizButton = UIButton()
        getQuizButton.setTitle("Get Quiz", for: .normal)
        getQuizButton.isUserInteractionEnabled = true
        getQuizButton.addTarget(self, action: #selector(self.getQuiz(_:)), for: .touchUpInside)
        container.addSubview(getQuizButton)
        
        funFactImageView = UIImageView(image: UIImage(named: "lightbulb"))
        quizlistContainer.addSubview(funFactImageView)
        
        funFactLabel = UILabel()
        funFactLabel.text = "Fun fact"
        quizlistContainer.addSubview(funFactLabel)
        
        funFactBody = UILabel()
        funFactBody.text = ""
        funFactBody.lineBreakMode = .byWordWrapping
        funFactBody.numberOfLines = 0
        quizlistContainer.addSubview(funFactBody)
        
        
        quizlistCollectionView = {
            //try to subclass into QuizzesViewFlowLayout() for more responsive design on bigger screens
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.headerReferenceSize = CGSize(width: 0, height: 56)
            // sets to smallest needed size, not fixed size per section
            //layout.estimatedItemSize = QuizzesViewFlowLayout.automaticSize
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            return collectionView
        }()
        quizlistCollectionView?.delegate = self
        quizlistCollectionView?.dataSource = self
        quizlistCollectionView.register(QuizzesViewCell.self, forCellWithReuseIdentifier: "QuizCell")
        quizlistCollectionView.register(QuizHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(QuizHeaderView.self)")  // UICollectionReusableView
        quizlistContainer.addSubview(quizlistCollectionView)
    }
    
    private func styleViews() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "SourceSansPro-Bold", size: 24.0)
        
        getQuizButton.backgroundColor = .white
        getQuizButton.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: inputFieldFontSize)
        getQuizButton.setTitleColor(colorButtonText, for: .normal)
        getQuizButton.layer.cornerRadius = inputFieldCornerRadius
        
        quizlistContainer.backgroundColor = .clear
        quizlistCollectionView.backgroundColor = .clear
        
        funFactLabel.textColor = .white
        funFactLabel.font = UIFont(name: "SourceSansPro-Bold", size: 24.0)
        
        funFactBody.textColor = .white
        funFactBody.font = UIFont(name: "SourceSansPro-SemiBold", size: 18.0)
    }
    
    private func defineLayoutForViews() {
        container.translatesAutoresizingMaskIntoConstraints = false
        quizlistContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        getQuizButton.translatesAutoresizingMaskIntoConstraints = false
        funFactImageView.translatesAutoresizingMaskIntoConstraints = false
        funFactLabel.translatesAutoresizingMaskIntoConstraints = false
        funFactBody.translatesAutoresizingMaskIntoConstraints = false
        quizlistCollectionView.translatesAutoresizingMaskIntoConstraints = false

        let getQuizButtonLeading = getQuizButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30)
        let getQuizButtonTrailing = getQuizButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30)
        
        getQuizButtonLeading.priority = UILayoutPriority(750)
        getQuizButtonTrailing.priority = UILayoutPriority(750)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            quizlistContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 210),
            quizlistContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            quizlistContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            quizlistContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            quizlistCollectionView.topAnchor.constraint(equalTo: funFactBody.bottomAnchor, constant: 10),
            quizlistCollectionView.leadingAnchor.constraint(equalTo: quizlistContainer.leadingAnchor),
            quizlistCollectionView.trailingAnchor.constraint(equalTo: quizlistContainer.trailingAnchor),
            quizlistCollectionView.bottomAnchor.constraint(equalTo: quizlistContainer.bottomAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 61),
            
            getQuizButtonLeading,
            getQuizButtonTrailing,
            getQuizButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            getQuizButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 123),
            getQuizButton.widthAnchor.constraint(lessThanOrEqualToConstant: inputFieldMaxWidth),
            getQuizButton.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            
            funFactImageView.topAnchor.constraint(equalTo: quizlistContainer.topAnchor, constant: 4),
            funFactImageView.leadingAnchor.constraint(equalTo: quizlistContainer.leadingAnchor, constant: 24),
            funFactImageView.heightAnchor.constraint(equalToConstant: 28),
            funFactImageView.widthAnchor.constraint(equalToConstant: 28),
            
            funFactLabel.topAnchor.constraint(equalTo: quizlistContainer.topAnchor, constant: 4),
            funFactLabel.leadingAnchor.constraint(equalTo: funFactImageView.trailingAnchor, constant: 10),
            
            funFactBody.topAnchor.constraint(equalTo: funFactLabel.bottomAnchor, constant: 10),
            funFactBody.leadingAnchor.constraint(equalTo: quizlistContainer.leadingAnchor, constant: 24),
            funFactBody.trailingAnchor.constraint(equalTo: quizlistContainer.trailingAnchor, constant: -24)
        ])
    }
    
    // getQuizButton target
    @objc func getQuiz(_: UIButton) {
        quizlistContainer.isHidden = false
        quizlist = ds.fetchQuizes()
        quizlistByCategory = distributeByCategory(list: quizlist)
        self.quizlistCollectionView.performBatchUpdates({
            // seems slow, maybe consider other options later
            self.quizlistCollectionView.reloadData()
        }, completion: nil)
        
        let occurences = getOccurencesInQuizQuestions(string: "NBA")
        funFactBody.text =
        """
        There are \(String(occurences)) questions that contain the word "NBA".
        """
    }
    
    private func getOccurencesInQuizQuestions(string: String) -> Int {
        if quizlist == nil {
            return 0
        }
        var total = 0
        for quiz in quizlist {
            let inCurrentQuiz = quiz.questions.map{$0.question.contains(string) ? 1 : 0}.filter{$0 == 1}.count
            total = total + inCurrentQuiz
        }
        return total
    }
    
}

extension QuizzesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if quizlistByCategory?.isEmpty ?? true {
            return 0
        } else {
            // this should later be changed to count non-empty elements
            return quizlistByCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if quizlist == nil {
            return 0
        }
        var items = 0
        let category: QuizCategory!
        switch section {
        case 0:
            category = .sport
        case 1:
            category = .science
        default:
            category = nil
        }
        
        // this could be replaced by a count over quizlistByCategory[section]
        for quiz in quizlist {
            if quiz.category == category {
                items = items + 1
            }
        }
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCell", for: indexPath) as! QuizzesViewCell
        let currentQuiz = quizlistByCategory[indexPath[0]][indexPath[1]]
        
        cell.quizTitle.text = currentQuiz.title
        cell.quizDescription.text = currentQuiz.description
        
        //determine which thumbnail to show, a bit crude but temporary
        var image: UIImage!
        image = UIImage(named: "quiz-sport-intermediate")
        let str = cell.quizTitle.text
        if (str?.contains("Basic"))! {
            if (str?.contains("sport"))! {
                image = UIImage(named: "quiz-sport-basic")
            } else if (str?.contains("science"))! {
                image = UIImage(named: "quiz-science-basic")
            }
        } else {
            image = UIImage(named: "quiz-sport-intermediate")
        }
        cell.thumbnail.image = image
        cell.setLevel(level: currentQuiz.level)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(QuizHeaderView.self)", for: indexPath) as! QuizHeaderView
            
            var category: String!
            switch indexPath.section {
            case 0:
                category = "Sport"
            case 1:
                category = "Science"
            default:
                category = ""
            }
            headerView.titleLabel.text = category
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    /* Creates a two dimensional array from the original quiz array.
     * This makes it easier to index using indexPath
     */
    func distributeByCategory(list: [Quiz]) -> [[Quiz]] {
        // initialises the 2D array with 2 elements, since there are 2 category types
        var byCategory = [[Quiz](), [Quiz]()]
        for quiz in list {
            var catIndex: Int
            switch quiz.category {
            case .sport:
                catIndex = 0
            case .science:
                catIndex = 1
            }
            byCategory[catIndex].append(quiz)
        }
        return byCategory
    }
}


extension QuizzesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // logic for opening quizzes
    }
}


extension QuizzesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 143)
    }
}
