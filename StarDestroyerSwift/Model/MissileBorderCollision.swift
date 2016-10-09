//
//  MissileBorderCollision.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 18.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

struct MissileBorderCollision: Collision {
    
    //MARK: Properties
    
    let missile: Missile
    
    //MARK: Initializers
    
    init?(contact: SKPhysicsContact) {
        
        let borderBitmask: UInt32 = 0x1 << 5

        if let missile = contact.bodyA.node as? Missile, contact.bodyB.contactTestBitMask == borderBitmask {
            self.missile = missile
        } else if let missile = contact.bodyB.node as? Missile, contact.bodyA.contactTestBitMask == borderBitmask {
            self.missile = missile
        } else {
            return nil
        }

    }
    
}
