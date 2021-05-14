//
//  QuizHeaderView.swift
//  QuizApp
//
//  Created by five on 11/04/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class QuizHeaderView: UICollectionReusableView {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor(red: 0.95, green: 0.79, blue: 0.30, alpha: 1.00)
        titleLabel.font = UIFont(name: "SourceSansPro-Bold", size: 20.0)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
