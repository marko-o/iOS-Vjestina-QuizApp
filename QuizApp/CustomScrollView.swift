//
//  CustomScrollView.swift
//  QuizApp
//
//  Created by five on 15/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation
import UIKit

class CustomScrollView: UIScrollView {
    
    //allows scrolling if touch happens inside a button
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl
            && !(view is UITextInput)
            && !(view is UISlider)
            && !(view is UISwitch) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}
