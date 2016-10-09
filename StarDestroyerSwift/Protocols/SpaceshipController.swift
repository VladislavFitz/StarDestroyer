//
//  SpaceshipController.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 09.10.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

protocol SpaceshipController {
    
    var spaceship: Spaceship { get set }
    
    mutating func shoot(missileType: MissileType)
    
    func moveBy(direction: Direction)
    
}

extension SpaceshipController {
    
    mutating func shoot(missileType: MissileType) {
        spaceship.shoot(missileType: missileType)
    }
    
    func moveBy(direction: Direction) {
        spaceship.moveBy(direction: direction)
    }
    
}
