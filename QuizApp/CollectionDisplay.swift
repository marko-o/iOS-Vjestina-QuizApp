//
//  CollectionDisplay.swift
//  QuizApp
//
//  Created by five on 05/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

enum CollectionDisplay {
    case inline
    case list
    case grid(columns: Int)
}

extension CollectionDisplay : Equatable {
    
    public static func == (lhs: CollectionDisplay, rhs: CollectionDisplay) -> Bool {
        switch(lhs, rhs) {
        case (.inline, .inline), (.list, .list):
            return true
        case (.grid(let lColumn), .grid(let rColumn)):
            return lColumn == rColumn
        
        default:
            return false
        }
    }
}
