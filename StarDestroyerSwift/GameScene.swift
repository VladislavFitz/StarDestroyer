//
//  GameScene.swift
//  StarDestroyerSwift
//
//  Created by Vladislav Fitc on 19.06.16.
//  Copyright (c) 2016 Fitc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var game: Game!
        
    fileprivate let borderBitMask: UInt32 = 0x1 << 5
    
    lazy var initialPlayerPosition: CGPoint = {
        return CGPoint(x: 200, y: self.frame.size.height / 2)
    }()
    
    lazy var initialAiPosition: CGPoint = {
        return CGPoint(x: 800, y: self.frame.size.height / 2)
    }()
    
    var playerHealthLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "HelveticaNeue")
        label.fontSize = 40
        label.fontColor = .red
        label.horizontalAlignmentMode = .left
        return label
    }()
    
    var playerLifesLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "HelveticaNeue")
        label.fontSize = 40;
        label.horizontalAlignmentMode = .left
        return label
    }()
    
    var playerScoreLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "HelveticaNeue")
        label.fontSize = 40;
        label.horizontalAlignmentMode = .left
        label.fontColor = .green
        return label
    }()
    
    var timeLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "HelveticaNeue")
        return label
    }()
    
    var levelLabel : SKLabelNode = {
        let label = SKLabelNode(fontNamed: "HelveticeNeue")
        return label
    }()
    
    var messageLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Optima")
        label.fontSize = 70
        return label
    }()
    
    func showMessage(_ message: String, duration: TimeInterval = TimeInterval.infinity) {
        
        if !self.children.contains(messageLabel) {
            messageLabel.position = self.frame.center
            messageLabel.zPosition = 1.0
            self.addChild(messageLabel)
        }
        
        messageLabel.text = message
        
        messageLabel.run(.unhide())
        
        if duration != TimeInterval.infinity {
            messageLabel.run(SKAction.wait(forDuration: duration), completion: {
                self.hideMessage()
            }) 
        }
        
    }
    
    func hideMessage() {
        messageLabel.run(.hide())
    }
    
    func hideMessage(animated: Bool) {
        messageLabel.run(SKAction.fadeOut(withDuration: animated ? 1.5 : 0.0))
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupBackground()
        setupPhysics()
        
        restartGame()
    }
    
    
    func restartGame() {
        game = Game()
        game.delegate = self
        showMessage("Press space to start")
    }

}

extension GameScene {
    
    enum Key: Int {
        case specialShot = 0
        case left = 123
        case right = 124
        case down = 125
        case up = 126
        case rotate = 44
        case space = 49
        case enter = 36
        case ok = 1000
        case cancel = 1001
    }
    
    fileprivate func setupBackground() {
        let background = SKSpriteNode(imageNamed: "space")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = 0
        
        self.addChild(background)
    }
    
    fileprivate func setupPhysics() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self;
        self.physicsBody?.contactTestBitMask = borderBitMask
    }
    
    fileprivate func launchGameTimer() {

        let waitAction = SKAction.wait(forDuration: 1)
        let callTickAction = SKAction.run(tick, queue: DispatchQueue.main)
        
        let tickAction = SKAction.sequence([waitAction, callTickAction])
        let repeatingTickAction = SKAction.repeatForever(tickAction)
        
        run(repeatingTickAction, withKey: "tick")
    }
    
    fileprivate func tick() {
        
        game.tick()
        refreshLabels()

    }
    
    fileprivate func refreshLabels() {
        self.timeLabel.text =  "Time left: \(Int(game.timeLeft))"
    }
    
    fileprivate func setupInformationLabels() {
        
        timeLabel.position = CGPoint(x: frame.midX, y: frame.size.height - 30)
        timeLabel.zPosition = 5.0
        addChild(timeLabel)
        
        levelLabel .position = CGPoint(x: frame.midX, y: frame.size.height - 100)
        levelLabel.zPosition = 5.0
        addChild(levelLabel)
        
        playerHealthLabel.position = CGPoint(x: frame.origin.x + 50, y: frame.size.height - 150)
        playerHealthLabel.zPosition = 5.0
        addChild(playerHealthLabel)
        
        playerScoreLabel.position = CGPoint(x: frame.origin.x + 50, y: frame.size.height - 100)
        playerScoreLabel.zPosition = 5.0
        addChild(playerScoreLabel)
        
        playerLifesLabel.position = CGPoint(x: frame.origin.x + 50, y: frame.size.height - 50)
        playerLifesLabel.zPosition = 5.0
        addChild(playerLifesLabel)
        
        self.levelLabel.text = "Level: \(game.level)"
        self.playerScoreLabel.text = "Score: \(game.player.score)"
        refreshPlayerStates()
        
    }
    
    fileprivate func installPlayerSpaceship() {
        
        guard let playerSpaceshipNode = game.player.spaceship as? SKSpriteNode else { return }
        
        playerSpaceshipNode.position = initialPlayerPosition
        
        playerSpaceshipNode.xScale = 0.5
        playerSpaceshipNode.yScale = 0.5
        playerSpaceshipNode.zPosition = 2.0
        
        addChild(playerSpaceshipNode)
        
    }
    
    fileprivate func installAiSpaceship() {
        
        guard let aiSpaceshipNode = game.ai.spaceship as? SKSpriteNode else { return }
        
        aiSpaceshipNode.position = initialAiPosition
        
        aiSpaceshipNode.xScale = 0.5
        aiSpaceshipNode.yScale = 0.5
        aiSpaceshipNode.zPosition = 2.0
        
        addChild(aiSpaceshipNode)
        
    }
    
    func refreshPlayerStates() {
        self.playerHealthLabel.text = "Health: \(game.player.spaceship.health)"
        self.playerScoreLabel.text = "Score: \(game.player.score)"
        self.playerLifesLabel.text = "Spaceships left: \(game.player.spaceshipCount)"
    }
    
    override func keyDown(with theEvent: NSEvent) {
        
        guard let key = Key(rawValue: Int(theEvent.keyCode)) else { return }
        
        switch key {
        case .up:
            game.player.moveBy(direction: .up)
        case .down:
            game.player.moveBy(direction: .down)
        case .left:
            game.player.moveBy(direction: .left)
        case .right:
            game.player.moveBy(direction: .right)
            
            
        case .specialShot:
            game.player.shoot(missileType: .white)
            
        case .space:
            switch game.state {
            case .initial:

                let hideWelcomeMessageAction = SKAction.run({ self.hideMessage() })
                
                let waitAction = SKAction.wait(forDuration: 2)
                
                let startGameAction = SKAction.run(game.start, queue: DispatchQueue.main)
                
                let showLabelsAction = SKAction.run(setupInformationLabels)
                
                let startGameSequence = SKAction.sequence([
                    hideWelcomeMessageAction,
                    waitAction,
                    showLabelsAction,
                    startGameAction
                    ]
                )
                
                run(startGameSequence)
                

                
            case .started:
                game.player.shoot(missileType: .red)
                
            default:
                break
            }
            
        default:
            break
        }
        
    }
    
}

extension GameScene: GameDelegate {
    
    func didStartGame(_ game: Game) {
        
        installPlayerSpaceship()
        installAiSpaceship()
                
        run(game.ai.clockAction(), withKey: "AIAction")
        
        launchGameTimer()
    }
    
    func didDestroyPlayerSpaceship(_ game: Game) {
        let wait = SKAction.wait(forDuration: 1)
        let installShip = SKAction.run(installPlayerSpaceship)
        let reinitAction = SKAction.sequence([wait, installShip])
        run(reinitAction)
    }
    
    func didDestroyAiSpaceship(_ game: Game) {
        let wait = SKAction.wait(forDuration: 1)
        let installShip = SKAction.run(installAiSpaceship)
        let reinitAction = SKAction.sequence([wait, installShip])
        run(reinitAction)

    }
    
    func didChangeGameLevel(_ game: Game) {
        self.levelLabel.text = "Level: \(game.level)"
        
        removeAction(forKey: "AIAction")
        run(game.ai.clockAction(), withKey: "AIAction")

    }
    
    func didChangePlayerStates(_ game: Game) {
        refreshPlayerStates()
    }
    
    func didFinishGame(_ game: Game) {
        
        removeAction(forKey: "tick")
        self.children.filter { child in
            return (child is SKLabelNode) || (child is Spaceship) || (child is Missile)
        }.forEach({ $0.removeFromParent() })
        
        showMessage("Game over")
        
        let wait = SKAction.wait(forDuration: 3.0)
        let showSaveScoreDialogAction = SKAction.run({
            self.hideMessage()
            self.showSaveScoreDialog(completion: self.restartGame)
        }, queue: DispatchQueue.main)
        
        let saveScoreAction = SKAction.sequence([wait, showSaveScoreDialogAction])
        
        run(saveScoreAction)
        
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let missileBorderCollision = MissileBorderCollision(contact: contact) {
            let missile = missileBorderCollision.missile
            missile.explose()
        }
        
        if let missileSpaceshipCollision = MissileSpaceshipCollision(contact: contact) {
            let missile = missileSpaceshipCollision.missile
            let spaceship = missileSpaceshipCollision.spaceship

            missile.explose()
            
            var collisionManager = SpaceshipCollisionManager(spaceship: spaceship)
            collisionManager.didCollidedWithWeapon(missile)
        }
        
        if let missilesCollision = MissilesCollision(contact: contact) {
            
            let firstMissile = missilesCollision.firstMissile
            let secondMissile = missilesCollision.secondMissile
            
            firstMissile.explose()
            secondMissile.explose()
            
        }
        
    }
}

//MARK: - Save score dialog

extension GameScene {

    func showSaveScoreDialog(completion: @escaping (Void) -> Void = {}) {
        
        let alert = NSAlert()
        alert.messageText = "Please, input your name"
        alert.icon = NSImage(named: "medal")
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        input.placeholderString = "Player name"
        
        alert.accessoryView = input
        
        alert.beginSheetModal(for: view!.window!) { returnCode in
            switch returnCode {
            case 1000:
                self.writeResult(forPlayerWithName: input.stringValue, withScore: Int(self.game.player.score))
                self.showResults(completion: completion)
            default:
                completion()
            }
        }
    }
    
    
    func showResults(completion: @escaping (Void) -> Void = {}) {
        
        let results = UserDefaults.standard.object(forKey: "StarDestroyerResults") as? [String: Int] ?? [:]
        
        let topFiveResults = Array(results
            .map({ name, score in (name, score) })
            .sorted(by: { (r1, r2) -> Bool in r1.1 > r2.1 })
            .prefix(5))
        
        let topResultsText = Array(topFiveResults.enumerated()).map { (index, element)  in
            String(format: "%i. %@ : %i points\n", arguments: [index + 1, element.0, element.1])
            }.reduce("", +)
        
        let alert = NSAlert()
        alert.messageText = "Top results"
        alert.icon = NSImage(named: "award")
        
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 120))
        textView.isEditable = false
        textView.string = topResultsText
        textView.backgroundColor = .clear
        textView.font = NSFont(name: "Helvetica Neue", size: 20)
        alert.accessoryView = textView
        alert.beginSheetModal(for: self.view!.window!) { _ in
            completion()
        }
        
    }
    
    
    func writeResult(forPlayerWithName playerName: String, withScore score: Int) {
        let standardDefaults = UserDefaults.standard
        var results = standardDefaults.object(forKey: "StarDestroyerResults") as? [String: Int] ?? [:]
        results[playerName] = score
        standardDefaults.set(results, forKey: "StarDestroyerResults")
    }
    
}
