//
//  MissilesCollision.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 18.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

struct MissilesCollision: Collision {
    
    //MARK: Properties
    
    let firstMissile: Missile
    let secondMissile: Missile
    
    //MARK: Initializers
    
    init?(contact: SKPhysicsContact) {
        
        if
            let firstMissile = contact.bodyA.node as? Missile,
            let secondMissile = contact.bodyB.node as? Missile
        {
            self.firstMissile = firstMissile
            self.secondMissile = secondMissile
        } else {
            return nil
        }
        
    }
    
}
