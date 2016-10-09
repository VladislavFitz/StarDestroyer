//
//  RedMissile.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

class RedMissile: SKSpriteNode, Missile {
    
    var damage: UInt { return 5 }
    
    fileprivate(set) var orientation: Orientation = .up
    
    var initialPosition: CGPoint = CGPoint() {
        didSet {
            self.position = initialPosition
        }
    }

    static var contactBitmask: UInt32 { return 1 << 3 }
    
    static func instantiate(_ orientation: Orientation) -> RedMissile {
        let missile = RedMissile(imageNamed: "Missile1")
        
        missile.orientation = orientation
        missile.size = CGSize(width: 40, height: 30);
        missile.zRotation = orientation.zRotation
        missile.speed = 10
        
        missile.physicsBody = SKPhysicsBody(texture: missile.texture!, size: missile.size)
        missile.physicsBody?.mass = 0.001;
        missile.physicsBody?.contactTestBitMask = contactBitmask
        
        return missile
    }
    
    func playExploseSound() {
        
    }
    
    func playLaunchSound() {
        let action = SKAction.playSoundFileNamed("missile1Launch.wav", waitForCompletion: false)
        run(action)
    }
    
}
