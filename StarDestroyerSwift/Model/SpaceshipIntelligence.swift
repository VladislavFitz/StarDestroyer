//
//  SpaceshipIntelligence.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 01.08.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

protocol SpaceShipIntelligenceDelegate: class {
    
    func intelligence(_ intelligence: SpaceshipIntelligence, didChangeHealthOfSpaceship spaceship: Spaceship)
    func intelligence(_ intelligence: SpaceshipIntelligence, didLoseSpaceship spaceship: Spaceship)
    
}

final class SpaceshipIntelligence: SpaceshipController {
    
    //MARK: Enums
    
    enum State {
        case active
        case paused
    }
    
    enum Decision: Int {
        case moveUp
        case moveDown
        case shoot
    }
    
    //MARK: Properties
    
    var spaceship: Spaceship
    var state: State = .paused
    var difficultyLevel: Int = 1
    weak var delegate: SpaceShipIntelligenceDelegate?
    
    //MARK: Initializers
    
    init(spaceship: Spaceship) {
        self.spaceship = spaceship
        self.spaceship.delegate = self
    }
    
    //MARK: Public functions
    
    func clockAction() -> SKAction {
        
        let decisionInterval: TimeInterval = Double(0.5) / Double(difficultyLevel)
        
        let waitAction = SKAction.wait(forDuration: decisionInterval)
        let takeDecisionAction = SKAction.run(makeDecision, queue: DispatchQueue.main)
        
        let aiClockAction = SKAction.sequence([waitAction, takeDecisionAction])
        let repeatingAiClockAction = SKAction.repeatForever(aiClockAction)
        
        return repeatingAiClockAction
    }
    
    func makeDecision() {
        let decision = Int(arc4random_uniform(3))
        
        switch decision {
        case 0:
            perform(decision: .moveUp)
        case 1:
            perform(decision: .moveDown)
        case 2:
            perform(decision: .shoot)
        default:
            break
        }
        
    }
    
    func perform(decision: Decision) {
        
        switch decision {
        case .moveDown:
            spaceship.moveBy(direction: .down)
        case .moveUp:
            spaceship.moveBy(direction: .up)
        case .shoot:
            spaceship.shoot(missileType: .red)
        }
        
    }
    
    
}

//MARK:- SpaceshipDelegate

extension SpaceshipIntelligence: SpaceshipDelegate {
    
    func didChangeHealthOfSpaceship(_ spaceship: Spaceship) {
        delegate?.intelligence(self, didChangeHealthOfSpaceship: spaceship)
    }
    
    func didDestroySpaceship(_ spaceship: Spaceship) {
        self.spaceship = spaceship.newInstance()
        self.spaceship.delegate = self
        delegate?.intelligence(self, didLoseSpaceship: spaceship)
    }
}
