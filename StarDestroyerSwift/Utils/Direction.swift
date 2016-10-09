//
//  Direction.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

enum Direction {
    
    case up, down, left, right
    
    func offsetWithDelta(_ delta: CGFloat) -> (byX: CGFloat, byY: CGFloat) {
                
        switch self {
        case .down:
            return (byX: 0, byY: -delta)
            
        case .up:
            return (byX: 0, byY: delta)
            
        case .left:
            return (byX: -delta, byY: 0)
            
        case .right:
            return (byX: delta, byY: 0)
        }
        
    }
}
