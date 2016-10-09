//
//  SpaceshipFactory.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

enum SpaceshipType {
    case red, blue
}

struct SpaceshipFactory {
    
    static func spaceshipWith(id: String, type: SpaceshipType, orientation: Orientation) -> Spaceship {
        switch type {
        case .red:
            return RedSpaceship.instantiate(id: id, orientation: orientation)
        case .blue:
            return BlueSpaceship.instantiate(id: id, orientation: orientation)
        }
    }
    
}
