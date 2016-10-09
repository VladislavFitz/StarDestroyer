//
//  MissileFactory.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

enum MissileType {
    case red, white
}

struct MissileFactory {
    
    static func missileWithType(_ type: MissileType, orientation: Orientation) -> Missile {
        
        switch type {
        case .red:
            return RedMissile.instantiate(orientation)
            
        case .white:
            return WhiteMissile.instantiate(orientation)
        }
    }
    
}
