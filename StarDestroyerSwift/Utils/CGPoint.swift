//
//  CGPoint.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 14.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

extension CGPoint {
    
    func distanceTo(point: CGPoint) -> CGFloat {
        let deltaX = self.x - point.x
        let deltaY = self.y - point.y
        return sqrt(pow(deltaX, 2) + pow(deltaY, 2))
    }
    
}
