//
//  WhiteMissile.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

class WhiteMissile: SKSpriteNode, Missile {
    
    var damage: UInt { return 5 }
    
    fileprivate(set) var orientation: Orientation = .up
    
    var initialPosition: CGPoint = CGPoint() {
        didSet {
            self.position = initialPosition
        }
    }
    
    static var contactBitmask: UInt32 { return 1 << 4 }
    
    static func instantiate(_ orientation: Orientation) -> WhiteMissile {
        let missile = WhiteMissile(imageNamed: "Missile2")
        
        missile.orientation = orientation
        missile.size = CGSize(width: 40, height: 30)
        missile.zRotation = orientation.zRotation
        missile.speed = 10
        
        missile.physicsBody = SKPhysicsBody(texture: missile.texture!, size: missile.size)
        missile.physicsBody?.mass = 0.001
        missile.physicsBody?.contactTestBitMask = contactBitmask

        
        return missile
    }
    
    func launch(formSpaceship spaceship: Spaceship, onScene scene: SKScene) {
        
        self.initialPosition = spaceship.outterInitialPosition()
        self.zPosition = 2.0
        scene.addChild(self)
        
        guard let enemyPosition = scene.children.flatMap({ $0 as? Spaceship }).filter({ $0.id != spaceship.id }).flatMap({ $0 as? SKNode }).first?.position else { return }
        
        
        launchToAimLocation(enemyPosition)
    }
    
    func playExploseSound() {

    }
    
    func playLaunchSound() {
        let action = SKAction.playSoundFileNamed("missile2Launch.wav", waitForCompletion: false)
        run(action)
    }
    
}
