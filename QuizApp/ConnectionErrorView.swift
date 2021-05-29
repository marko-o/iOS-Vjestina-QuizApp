//
//  ConnectionErrorView.swift
//  QuizApp
//
//  Created by five on 17/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class ConnectionErrorView: UIView {
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        titleLabel.text = "Error"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "SourceSansPro-Bold", size: 28.0)
        descriptionLabel.text = "Data can't be reached. \nPlease try again"
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont(name: "SourceSansPro-Regular", size: 16.0)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 6)
        descriptionLabel.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
