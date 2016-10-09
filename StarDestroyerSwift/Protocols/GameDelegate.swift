//
//  GameDelegate.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 09.10.16.
//  Copyright © 2016 Fitc. All rights reserved.
//

import Foundation

protocol GameDelegate: class {
    func didStartGame(_ game: Game)
    func didDestroyPlayerSpaceship(_ game: Game)
    func didDestroyAiSpaceship(_ game: Game)
    func didChangePlayerStates(_ game: Game)
    func didChangeGameLevel(_ game: Game)
    func didFinishGame(_ game: Game)
}
