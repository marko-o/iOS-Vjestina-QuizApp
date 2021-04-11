//
//  QuizzesViewCell.swift
//  QuizApp
//
//  Created by five on 10/04/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class QuizzesViewCell: UICollectionViewCell {
    var bg: UIView!
    
    var thumbnail: UIImageView!
    var quizTitle: UILabel!
    var quizDescription: UILabel!
    var levelIndicators: [UIView]!
    var levelIndicatorsContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        buildCell()
        styleCell()
        defineLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildCell() {
        bg = UIView()
        contentView.addSubview(bg)
        thumbnail = UIImageView()
        bg.addSubview(thumbnail)
        quizTitle = UILabel()
        bg.addSubview(quizTitle)
        quizDescription = UILabel()
        bg.addSubview(quizDescription)
        levelIndicators = [UIView(), UIView(), UIView()]
        levelIndicatorsContainer = UIView()
        bg.addSubview(levelIndicatorsContainer)
        
        // styling and constraints for levelIndicators
        for li in levelIndicators {
            levelIndicatorsContainer.addSubview(li)
        }
    }
    
    private func styleCell() {
        bg.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        bg.layer.cornerRadius = 10
        
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.layer.cornerRadius = 6
        thumbnail.layer.masksToBounds = true
        
        quizTitle.textColor = .white
        quizTitle.font = UIFont(name: "SourceSansPro-Bold", size: 24.0)
        quizTitle.lineBreakMode = .byWordWrapping
        quizTitle.numberOfLines = 0
        quizDescription.textColor = .white
        quizDescription.font = UIFont(name: "SourceSansPro-SemiBold", size: 14.0)
        quizDescription.lineBreakMode = .byWordWrapping
        quizDescription.numberOfLines = 0
        
        for li in levelIndicators {
            li.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
            li.layer.cornerRadius = 2
        }
    }
    
    private func defineLayoutConstraints() {
        bg.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        quizTitle.translatesAutoresizingMaskIntoConstraints = false
        quizDescription.translatesAutoresizingMaskIntoConstraints = false
        levelIndicatorsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints for level indicators
        var posOffset = CGFloat(0)
        for li in levelIndicators {
            li.translatesAutoresizingMaskIntoConstraints = false
            li.topAnchor.constraint(equalTo: levelIndicatorsContainer.topAnchor).isActive = true
            li.leadingAnchor.constraint(equalTo: levelIndicatorsContainer.leadingAnchor, constant: posOffset).isActive = true
            li.widthAnchor.constraint(equalToConstant: 10).isActive = true
            li.heightAnchor.constraint(equalToConstant: 10).isActive = true
            posOffset = posOffset + 18
            let degrees = Double(45)
            li.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180));
        }
        
        let bgTop = bg.topAnchor.constraint(equalTo: contentView.topAnchor)
        let bgLeading = bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let bgTrailing = bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bgBottom = bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        bgTop.priority = UILayoutPriority(750)
        bgLeading.priority = UILayoutPriority(750)
        bgTrailing.priority = UILayoutPriority(750)
        bgBottom.priority = UILayoutPriority(750)
        
        NSLayoutConstraint.activate([
            bgTop,
            bgLeading,
            bgTrailing,
            bgBottom,
            bg.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            bg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            thumbnail.leadingAnchor.constraint(equalTo: bg.leadingAnchor, constant: 20),
            thumbnail.topAnchor.constraint(equalTo: bg.topAnchor, constant: 20),
            thumbnail.heightAnchor.constraint(equalToConstant: 103),
            thumbnail.widthAnchor.constraint(equalToConstant: 103),
            
            quizTitle.topAnchor.constraint(equalTo: bg.topAnchor, constant: 26),
            quizTitle.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 18),
            quizTitle.trailingAnchor.constraint(equalTo: bg.trailingAnchor, constant: -18),
            quizDescription.topAnchor.constraint(equalTo: quizTitle.bottomAnchor, constant: 0),
            quizDescription.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 18),
            quizDescription.trailingAnchor.constraint(equalTo: bg.trailingAnchor, constant: -18),
            
            levelIndicatorsContainer.topAnchor.constraint(equalTo: bg.topAnchor, constant: 16),
            levelIndicatorsContainer.trailingAnchor.constraint(equalTo: bg.trailingAnchor, constant: -16),
            levelIndicatorsContainer.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // could add option for setting color later
    func setLevel(level: Int) {
        for i in 0..<level {
            levelIndicators[i].backgroundColor = UIColor(red: 0.95, green: 0.79, blue: 0.30, alpha: 1.00)
        }
    }
}
