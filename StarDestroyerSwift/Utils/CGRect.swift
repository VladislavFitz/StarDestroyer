//
//  CGRect.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 18.07.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }

    
}
