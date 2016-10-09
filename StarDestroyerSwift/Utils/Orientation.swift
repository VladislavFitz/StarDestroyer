//
//  Orientation.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

enum Orientation {
    
    case left, right, up, down
    
    var zRotation: CGFloat {
        
        switch self {
        case .down:
            return CGFloat(M_PI)
        case .up:
            return 0
        case .left:
            return CGFloat(M_PI_2)
        case .right:
            return CGFloat(-M_PI_2)
        }
        
    }
    
}
