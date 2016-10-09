//
//  Collision.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 09.10.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation
import SpriteKit

protocol Collision {
    init?(contact: SKPhysicsContact)
}
