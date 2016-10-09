//
//  PlayerDelegate.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 09.10.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

protocol PlayerDelegate: class {
    
    func player(_ player: Player, didChangeHealthOfSpaceship spaceship: Spaceship)
    func player(_ player: Player, didLoseSpaceship spaceship: Spaceship)
    
}
