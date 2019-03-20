//
//  GameScene.swift
//  Project11
//
//  Created by Stefan Milenkovic on 3/18/19.
//  Copyright © 2019 Stefan Milenkovic. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var boxCounter = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode = false{
        didSet {
            if editingMode {
                editLabel.text = "Done"
            }else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var ballLabel: SKLabelNode!
    var winLabel: SKLabelNode!
    
    var ballCounter = 5 {
        didSet {
            ballLabel.text = "Remainingg balls: \(ballCounter)"
        }
        
    }
    
    
    
    override func didMove(to view: SKView) {
        
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        winLabel = SKLabelNode(fontNamed: "Chalkduster")
        winLabel.text = "YOU WIN!!!"
        winLabel.horizontalAlignmentMode = .center
        winLabel.position = CGPoint(x: 514, y: frame.size.height / 2.0)
        winLabel.isHidden = true
        addChild(winLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        
        ballLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballLabel.text = "Remaining balls: 5"
        ballLabel.horizontalAlignmentMode = .center
        ballLabel.position = CGPoint(x: 512, y: 700)
        addChild(ballLabel)
        
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        //editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        addChild(scoreLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var ballColors = ["ballRed","ballYellow","ballBlue","ballGreen","ballCyan","ballPurple", "ballGrey"]
        
        
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        if objects.contains(editLabel) {
            editingMode.toggle()
        }else {
            if editingMode {
                // create box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                addChild(box)
                boxCounter += 1
                
            }else {
                
                let index = Int.random(in: 0..<ballColors.count)
                
                let ball = SKSpriteNode(imageNamed: "\(ballColors[index])")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.name = "ball"
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location
                ball.position.y = 700
                
            
                if ballCounter != 0 {
                addChild(ball)
                    ballCounter -= 1

                }
            }
            
           
        }
        
        
       
        
    }
    
    
    func makeBouncer(at position: CGPoint) {
        
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.frame.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
        
        
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
 
    }
    
    func collison(ball: SKNode, object: SKNode) {
        
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
        }else if object.name == "bad"{
            destroy(ball: ball)
            score -= 1
        }
        
        
        
    }
    
    func collisionBallAndBox(ball: SKNode, box: SKNode) {
        
        if box.name == "box" {
            destroyBox(box: box)
        }
        
        
    }
    
    func destroyBox(box: SKNode) {
        
        box.removeFromParent()
        boxCounter -= 1
        if boxCounter == 0 {
            ballCounter = 5
            winLabel.isHidden = false
        }else if boxCounter > 0 && ballCounter == 0 {
            winLabel.isHidden = false
            winLabel.text = "YOU LOSE!!!"
        }
    }
    
    func destroy(ball: SKNode) {
        
        if let fireParicles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParicles.position = ball.position
            addChild(fireParicles)
        }
        
        ball.removeFromParent()
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {
            return
        }
        guard let nodeB = contact.bodyB.node else {
            return
        }
        
        
        if nodeA.name == "ball" {
            collison(ball: nodeA, object: nodeB)
            collisionBallAndBox(ball: nodeA, box: nodeB)
        }else if nodeB.name == "ball"{
            collison(ball: nodeB, object: nodeA)
            collisionBallAndBox(ball: nodeB, box: nodeA)
        }
    }
}
