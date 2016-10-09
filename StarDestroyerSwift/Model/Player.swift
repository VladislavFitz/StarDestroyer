//
//  Player.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 01.08.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

class Player: SpaceshipController {
    
    //MARK: Properties
    
    var spaceship: Spaceship
    
    var spaceshipCount: UInt
    var score: UInt
    
    weak var delegate: PlayerDelegate?
    
    //MARK: Initializers
    
    init(spaceship: Spaceship) {
        self.spaceshipCount = 3
        self.score = 0
        self.spaceship = spaceship
        self.spaceship.delegate = self
    }
    
}

//MARK:- SpaceshipDelegate

extension Player: SpaceshipDelegate {
    
    func didDestroySpaceship(_ spaceship: Spaceship) {
        spaceshipCount = (spaceshipCount - 1)
        self.spaceship = spaceship.newInstance()
        self.spaceship.delegate = self
        delegate?.player(self, didLoseSpaceship: spaceship)
    }
    
    func didChangeHealthOfSpaceship(_ spaceship: Spaceship) {
        delegate?.player(self, didChangeHealthOfSpaceship: spaceship)
    }
    
}
