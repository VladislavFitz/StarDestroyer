//
//  Spaceship.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 19.06.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

protocol SpaceshipDelegate: class {
    func didChangeHealthOfSpaceship(_ spaceship: Spaceship)
    func didDestroySpaceship(_ spaceship: Spaceship)
}

protocol Spaceship {
    
    static var contactBitmask: UInt32 { get }
    
    var id: String { get }
    var level: UInt { get }
    var health: UInt { get set }
    var maxHealth: UInt { get }
    var reloadingTime: TimeInterval { get }
    var isReloading: Bool { get set }
    var moveStep: CGFloat { get }
    var orientation: Orientation { get }
    var destroyed: Bool { get }
    weak var delegate: SpaceshipDelegate? { get set }
    
    mutating func shoot(missileType: MissileType)
    
    mutating func damageWithPoints(_ damagePoints: UInt)
    
    func moveBy(direction: Direction)
    
    func newInstance() -> Self
    func outterInitialPosition() -> CGPoint
    
}

extension Spaceship where Self: SKSpriteNode {
    
    //MARK: Properties
    
    var maxHealth: UInt { return 100 }
    
    var destroyed: Bool { return health == 0 }
    
    //MARK: Public functions
    
    mutating func shoot(missileType: MissileType) {
        guard let scene = self.parent as? SKScene, !isReloading else { return }
        
        isReloading = true
        let waitAction = SKAction.wait(forDuration: 0.5)
        let releaseAction = SKAction.run({ [weak self] in self?.isReloading = false }, queue: DispatchQueue.main)
        let reloadingAction = SKAction.sequence([waitAction, releaseAction])
        
        self.run(reloadingAction)
        
        var missile = MissileFactory.missileWithType(missileType, orientation: self.orientation)
        missile.launch(formSpaceship: self, onScene: scene)
    }
    
    func outterInitialPosition() -> CGPoint {
        let offset: CGFloat = 10
        switch orientation {
        case .down:
            return CGPoint(x: position.x, y: frame.minY - offset)
        case .up:
            return CGPoint(x: position.x, y: frame.maxY + offset)
        case .left:
            return CGPoint(x: frame.minX - offset, y: position.y)
        case .right:
            return CGPoint(x: frame.maxX + offset, y: position.y)
        }
    }
    
    func moveBy(direction: Direction) {
    
        guard let parentNode = self.parent else { return }
        
        let moveOffset = direction.offsetWithDelta(moveStep)
        
        let currentFrame = self.frame
        
        let newFrame = CGRect(x: currentFrame.origin.x + moveOffset.byX, y: currentFrame.origin.y + moveOffset.byY, width: currentFrame.width, height: currentFrame.height)
        
        let battleFieldInset: CGFloat = 5.0
                
        let battleField = parentNode.frame.insetBy(dx: battleFieldInset, dy: battleFieldInset)
        
        if battleField.contains(newFrame) {
            let action = SKAction.moveBy(x: moveOffset.byX, y: moveOffset.byY, duration: 0.1)
            
            run(action)
        }
        
    }
    
    mutating func damageWithPoints(_ damagePoints: UInt) {
        
        guard !destroyed else { return }
        
        if damagePoints >= health {
            self.health = 0
            self.removeFromParent()
            delegate?.didDestroySpaceship(self)
        } else {
            health -= damagePoints
            delegate?.didChangeHealthOfSpaceship(self)
        }
        
    }
    
    
}
