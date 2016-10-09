//
//  MissileSpaceshipCollision.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 18.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

struct MissileSpaceshipCollision: Collision {
    
    //MARK: Properties
    
    let missile: Missile
    let spaceship: Spaceship
    
    //MARK: Initializers
    
    init?(contact: SKPhysicsContact) {
        
        if let missile = contact.bodyA.node as? Missile, let spaceship = contact.bodyB.node as? Spaceship {
            self.missile = missile
            self.spaceship = spaceship
        } else if let missile = contact.bodyB.node as? Missile, let spaceship = contact.bodyA.node as? Spaceship {
            self.missile = missile
            self.spaceship = spaceship
        } else {
            return nil
        }
        
    }
    
}
