//
//  RedSpaceship.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

final class RedSpaceship: SKSpriteNode, Spaceship {
    
    //MARK: Properties
    
    var id: String = ""
    
    fileprivate(set) var level: UInt = 1
    var health: UInt = 100
    fileprivate(set) var orientation: Orientation = .up
    
    let moveStep: CGFloat = 30
    
    weak var delegate: SpaceshipDelegate?
    
    var reloadingTime: TimeInterval {
        let baseReloadingTime: TimeInterval = 2
        return baseReloadingTime - TimeInterval(Double(level) * 0.35)
    }
    
    var isReloading: Bool = false
    
    static var contactBitmask: UInt32 = 0x1 << 1
    
    //MARK: Public functions
    
    static func instantiate(id: String, orientation: Orientation) -> RedSpaceship {
        
        let spaceShipSpriteNode = RedSpaceship(imageNamed: "redShip")
        spaceShipSpriteNode.id = id
        
        spaceShipSpriteNode.orientation = orientation
        
        let offsetX = spaceShipSpriteNode.size.width * spaceShipSpriteNode.anchorPoint.x
        let offsetY = spaceShipSpriteNode.size.height * spaceShipSpriteNode.anchorPoint.y

        let pathPoints: [CGPoint] = [
            (x: 110, y: 220),
            (x: 0, y: 220),
            (x: 0, y: 0),
            (x: 340, y: 0),
            (x: 340, y: 220),
            (x: 220, y: 220),
            (x: 220, y: 340),
            (x: 110, y: 340)
            ].map({ (x: $0.x - offsetX, y: $0.y - offsetY ) })
            .map({ (x, y) in CGPoint(x: x, y: y) })
        
        let initialPathPoint = pathPoints.first!
        
        let path = CGMutablePath()
        
        path.move(to: initialPathPoint)
        
        pathPoints.dropFirst().forEach({ path.addLine(to: $0) })
        
        path.closeSubpath()
        
        spaceShipSpriteNode.physicsBody = SKPhysicsBody(polygonFrom: path)
        spaceShipSpriteNode.physicsBody?.mass = 100.0
        spaceShipSpriteNode.physicsBody?.contactTestBitMask = contactBitmask
        spaceShipSpriteNode.physicsBody?.allowsRotation = true
        
        spaceShipSpriteNode.zRotation = orientation.zRotation
        
        return spaceShipSpriteNode
    }
    
    func newInstance() -> RedSpaceship {
        return SpaceshipFactory.spaceshipWith(id: self.id, type: .red, orientation: orientation) as! RedSpaceship
    }
    
}
