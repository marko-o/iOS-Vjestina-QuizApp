//
//  QuizzesViewCell.swift
//  QuizApp
//
//  Created by five on 10/04/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

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
        bg.autoPinEdgesToSuperviewEdges()
        
        thumbnail.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        thumbnail.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        thumbnail.autoSetDimensions(to: CGSize(width: 103, height: 103))

        quizTitle.autoPinEdge(toSuperviewEdge: .top, withInset: 28)
        quizTitle.autoPinEdge(.leading, to: .trailing, of: thumbnail, withOffset: 18)
        quizTitle.autoPinEdge(toSuperviewEdge: .trailing, withInset: 18)
        
        quizDescription.autoPinEdge(.top, to: .bottom, of: quizTitle)
        quizDescription.autoPinEdge(.leading, to: .trailing, of: thumbnail, withOffset: 18)
        quizDescription.autoPinEdge(toSuperviewEdge: .trailing, withInset: 18)
        
        levelIndicatorsContainer.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        levelIndicatorsContainer.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        levelIndicatorsContainer.autoSetDimension(.width, toSize: 50)
        
        var posOffset = CGFloat(0)
        for li in levelIndicators {
            li.autoPinEdge(toSuperviewEdge: .top)
            li.autoPinEdge(toSuperviewEdge: .leading, withInset: posOffset)
            li.autoSetDimensions(to: CGSize(width: 10, height: 10))
            posOffset = posOffset + 18
            let degrees = Double(45)
            li.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180));
        }
    }
    
    // could add option for setting color later
    func setLevel(level: Int) {
        for i in 0..<level {
            levelIndicators[i].backgroundColor = UIColor(red: 0.95, green: 0.79, blue: 0.30, alpha: 1.00)
        }
    }
}
