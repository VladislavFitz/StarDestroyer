//
//  Game.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 18.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

class Game {
    
    //MARK: Enums
    
    enum State {
        case initial, started, finished
    }
    
    //MARK: Properties
    
    weak var delegate: GameDelegate?
    
    var levelDuration: TimeInterval = 10.0
    var maxLevel: UInt = 5
    
    var player: Player

    var ai: SpaceshipIntelligence
    
    var state: State {
        didSet {
            switch state {
            case .initial:
                break
                
            case .started:
                break
                
            case .finished:
                break
            }
        }
    }
    
    var level: UInt
    var timeLeft: TimeInterval
    var duration: TimeInterval
    
    //MARK: Initializers
    
    init() {
        state = .initial
        
        let playerSpaceship = SpaceshipFactory.spaceshipWith(id: "player", type: .red, orientation: .right)
        player = Player(spaceship: playerSpaceship)

        let enemySpaceship = SpaceshipFactory.spaceshipWith(id: "enemy", type: .blue, orientation: .left)
        ai = SpaceshipIntelligence(spaceship: enemySpaceship)
        
        level = 1
        timeLeft = levelDuration
        duration = 0
        
        player.delegate = self
        ai.delegate = self

    }
    
    //MARK: Public functions
    
    func start() {
        state = .started
        delegate?.didStartGame(self)
    }
    
    func tick() {
        
        duration = duration + 1
        timeLeft = timeLeft - 1
        
        if timeLeft == 0 {
            if level == maxLevel {
                state = .finished
                delegate?.didFinishGame(self)
            } else {
                level = (level + 1)
                ai.difficultyLevel = ai.difficultyLevel + 1
                timeLeft = levelDuration
                delegate?.didChangeGameLevel(self)
            }
        }
                
    }
    
    
}

//MARK:- PlayerDelegate

extension Game: PlayerDelegate {
    
    func player(_ player: Player, didChangeHealthOfSpaceship spaceship: Spaceship) {
        delegate?.didChangePlayerStates(self)
    }
    
    func player(_ player: Player, didLoseSpaceship spaceship: Spaceship) {
        delegate?.didChangePlayerStates(self)
        delegate?.didDestroyPlayerSpaceship(self)
        if player.spaceshipCount == 0 {
            delegate?.didFinishGame(self)
        }
    }
    
}

//MARK:- SpaceShipIntelligenceDelegate

extension Game: SpaceShipIntelligenceDelegate {
    
    func intelligence(_ intelligence: SpaceshipIntelligence, didChangeHealthOfSpaceship spaceship: Spaceship) {
        player.score += 10
        delegate?.didChangePlayerStates(self)
    }
    
    func intelligence(_ intelligence: SpaceshipIntelligence, didLoseSpaceship spaceship: Spaceship) {
        player.score += 50
        delegate?.didChangePlayerStates(self)
        delegate?.didDestroyAiSpaceship(self)
    }
    
}
