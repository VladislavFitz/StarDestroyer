//
//  Missile.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 19.06.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit


protocol Missile: Weapon, Explodable {
    
    static var contactBitmask: UInt32 { get }

    var damage: UInt { get }
    var orientation: Orientation { get }
    
    var initialPosition: CGPoint { get set }
    
    func playLaunchSound()
    func launchToAimLocation(_ aimLocation: CGPoint)
    mutating func launch(formSpaceship spaceship: Spaceship, onScene scene: SKScene)
    
}

extension Missile where Self: SKSpriteNode {
    
    mutating func launch(formSpaceship spaceship: Spaceship, onScene scene: SKScene) {
        self.initialPosition = spaceship.outterInitialPosition()
        self.zPosition = 2.0
        scene.addChild(self)
        
        let sceneFrame = scene.frame
        
        let aimLocation: CGPoint
        
        switch self.orientation {
        case .down:
            aimLocation = CGPoint(x: initialPosition.x, y: 0)
        case .up:
            aimLocation = CGPoint(x: initialPosition.x, y: sceneFrame.maxY)
        case .left:
            aimLocation = CGPoint(x: sceneFrame.minX, y: initialPosition.y)
        case .right:
            aimLocation = CGPoint(x: sceneFrame.maxX, y: initialPosition.y)
        }
        
        launchToAimLocation(aimLocation)
    }
    
    func launchToAimLocation(_ aimLocation: CGPoint) {
        playLaunchSound()
        let distance = self.position.distanceTo(point: aimLocation)
        let duration = TimeInterval(distance / speed)
        let launchAction = SKAction.move(to: aimLocation, duration: duration)
        run(launchAction)
    }
    
    func explose() {
        
        let playSoundAction = SKAction.playSoundFileNamed("missileExplosion.wav", waitForCompletion: true)
        let disappearAction = SKAction.perform(#selector(removeFromParent), onTarget: self)
        
        let sequence = SKAction.sequence([playSoundAction, disappearAction])
        
        self.run(sequence)
    }
    
}
