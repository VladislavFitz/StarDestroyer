//
//  SpaceshipCollisionManager.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 18.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

struct SpaceshipCollisionManager {
    
    //MARK: Properties
    
    var spaceship: Spaceship
    
    //MARK: Public functions
    
    mutating func didCollidedWithWeapon(_ weapon: Weapon) {
        spaceship.damageWithPoints(weapon.damage)
    }
    
}
