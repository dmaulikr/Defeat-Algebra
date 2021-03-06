//
//  Hero.swift
//  DefeatAlgebra
//
//  Created by yo hanashima on 2017/07/09.
//  Copyright © 2017年 yo hanashima. All rights reserved.
//

import Foundation
import SpriteKit

class HeroForTutorial: SKSpriteNode {
    
    var direction: Direction = .back
    var moveDirection: MoveDirection = .Horizontal
    var moveSpeed = 0.2
    var heroMoveAnimation: SKAction!
    var moveLevel: Int = 1
    var attackDoneFlag = false
    var moveDoneFlag = false
    var aliveFlag = true
    var attackType: Int = 0
    
    
    /* position at grid */
    var positionX: Int = 4
    var positionY: Int = 3
    
    init() {
        /* Initialize with enemy asset */
        let texture = SKTexture(imageNamed: "heroFront")
        let heroSize = CGSize(width: 50, height: 50)
        super.init(texture: texture, color: UIColor.clear, size: heroSize)
        
        /* Set Z-Position, ensure ontop of grid */
        zPosition = 4
        
        /* Set anchor point to bottom-left */
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        /* Set physics property */
        physicsBody = SKPhysicsBody(rectangleOf: heroSize)
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 4294967258

        setName()
        setTexture()
        setMovingAnimation()
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* Set name */
    func setName() {
        self.name = "hero"
    }
    
    /* Set texture to hero according to direction */
    func setTexture() {
        switch direction {
        case .front:
            self.texture = SKTexture(imageNamed: "heroFront")
        case .back:
            self.texture = SKTexture(imageNamed: "heroBack")
        case .left:
            self.texture = SKTexture(imageNamed: "heroLeft")
        case .right:
            self.texture = SKTexture(imageNamed: "heroRight")
        }
    }
    /* Set animation to hero according to direction */
    func setMovingAnimation() {
        switch direction {
        case .front:
            self.heroMoveAnimation = SKAction(named: "heroMoveForward")!
            self.run(heroMoveAnimation)
        case .back:
            self.heroMoveAnimation = SKAction(named: "heroMoveBackward")!
            self.run(heroMoveAnimation)
        case .left:
            self.heroMoveAnimation = SKAction(named: "heroMoveLeft")!
            self.run(heroMoveAnimation)
        case .right:
            self.heroMoveAnimation = SKAction(named: "heroMoveRight")!
            self.run(heroMoveAnimation)
        }
    }
    
    /* Set hero direction when attacking */
    func setHeroDirection(posX: Int, posY: Int) {
        /* Calculate difference between current position and destination */
        let diffX = posX - self.positionX
        let diffY = posY - self.positionY
        
        /* turn right */
        if diffX > 0 {
            self.direction = .right
        /* turn left */
        } else if diffX < 0 {
            self.direction = .left
        } else {
            /* turn front */
            if diffY < 0 {
                self.direction = .front
            /* turn back */
            } else if diffY < 0 {
                self.direction = .back
            }
        }
    }
    
    /* Set hero sword attack animation */
    func setSwordAnimation() {
        switch direction {
        case .front:
            self.anchorPoint = CGPoint(x: 0.5, y: 1)
            let heroSwordAnimation = SKAction(named: "heroSwordBackward")!
            self.run(heroSwordAnimation)
        case .back:
            self.anchorPoint = CGPoint(x: 0.5, y: 0)
            let heroSwordAnimation = SKAction(named: "heroSwordForward")!
            self.run(heroSwordAnimation)
        case .left:
            self.anchorPoint = CGPoint(x: 1, y: 0.5)
            let heroSwordAnimation = SKAction(named: "heroSwordLeft")!
            self.run(heroSwordAnimation)
        case .right:
            self.anchorPoint = CGPoint(x: 0, y: 0.5)
            let heroSwordAnimation = SKAction(named: "heroSwordRight")!
            self.run(heroSwordAnimation)
        }
    }
    
    /* Set hero spear attack animation */
    func setSpearAnimation() {
        switch direction {
        case .front:
           self.anchorPoint = CGPoint(x: 0.5, y: 1)
            let heroSwordAnimation = SKAction(named: "heroSpearBackward")!
            self.run(heroSwordAnimation)
            break;
        case .back:
            self.anchorPoint = CGPoint(x: 0.5, y: 0)
            let heroSwordAnimation = SKAction(named: "heroSpearForward")!
            self.run(heroSwordAnimation)
            break;
        case .left:
            self.anchorPoint = CGPoint(x: 1, y: 0.5)
            let heroSwordAnimation = SKAction(named: "heroSpearLeft")!
            self.run(heroSwordAnimation)
            break;
        case .right:
            self.anchorPoint = CGPoint(x: 0, y: 0.5)
            let heroSpearAnimation = SKAction(named: "heroSpearRight")!
            self.run(heroSpearAnimation)
        }
    }
    
    /* Set hero multi sword attack animation */
    func setMultiSwordAttackAnimation() {
        /* front */
        let changeAnchorFront = SKAction.run({ self.anchorPoint = CGPoint(x: 0.5, y: 1) })
        let heroSwordAnimationFront = SKAction(named: "heroSwordBackward")!
        /* back */
        let changeAnchorBack = SKAction.run({ self.anchorPoint = CGPoint(x: 0.5, y: 0) })
        let heroSwordAnimationBack = SKAction(named: "heroSwordForward")!
        /* left */
        let changeAnchorLeft = SKAction.run({ self.anchorPoint = CGPoint(x: 1, y: 0.5) })
        let heroSwordAnimationLeft = SKAction(named: "heroSwordLeft")!
        /* right */
        let changeAnchorRight = SKAction.run({ self.anchorPoint = CGPoint(x: 0, y: 0.5) })
        let heroSwordAnimationRight = SKAction(named: "heroSwordRight")!
        let seq = SKAction.sequence([changeAnchorFront, heroSwordAnimationFront, changeAnchorBack, heroSwordAnimationBack, changeAnchorLeft, heroSwordAnimationLeft, changeAnchorRight, heroSwordAnimationRight])
        self.run(seq)
    }
    
    
    /* Move hero */
    func heroSingleMove() {
        /* Get parent Scene */
        let gameScene = self.parent as! Tutorial
        
        /* Set texture and animation */
        self.setTexture()
        self.setMovingAnimation()

        switch direction {
        case .front:
            /* Move hero backward */
            let move = SKAction.moveBy(x: 0, y: -CGFloat(gameScene.gridNode.cellHeight), duration: self.moveSpeed)
            self.run(move)
            break;
        case .back:
            /* Move hero forward */
            let move = SKAction.moveBy(x: 0, y: CGFloat(gameScene.gridNode.cellHeight), duration: self.moveSpeed)
            self.run(move)
            break;
        case .left:
            /* Move hero left */
            let move = SKAction.moveBy(x: -CGFloat(gameScene.gridNode.cellWidth), y: 0, duration: self.moveSpeed)
            self.run(move)
            break;
        case .right:
            /* Move hero right */
            let move = SKAction.moveBy(x: CGFloat(gameScene.gridNode.cellWidth), y: 0, duration: self.moveSpeed)
            self.run(move)
            break;
        }
    }
    
    func heroMoveToDest(posX: Int, posY: Int) {
        /* Calculate difference between current position and destination */
        let diffX = posX - self.positionX
        let diffY = posY - self.positionY
        
        if self.moveDirection == .Horizontal {
            /* Move right */
            if diffX > 0 {
                self.direction = .right
                
                /* Move forward */
                if diffY > 0 {
                    /* Move horizontaly */
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: diffX)
                    
                    /* Wait for move horizotaly done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(diffX)+0.3)) /* 0.3 is buffer */
                    
                    /* Move verticaly */
                    let changeDirect = SKAction.run({ self.direction = .back })
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: diffY)
                    
                    let seq = SKAction.sequence([moveToDestX, wait, changeDirect, moveToDestY])
                    self.run(seq)
                    
                    /* Move backward */
                } else if diffY < 0 {
                    /* Move horizontaly */
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: diffX)
                    
                    /* Wait for move horizotaly done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(diffX)+0.1)) /* 0.1 is buffer */
                    
                    /* Move verticaly */
                    let changeDirect = SKAction.run({ self.direction = .front })
                    let singleMove = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMove, count: -diffY)
                    
                    let seq = SKAction.sequence([moveToDestX, wait, changeDirect, moveToDestY])
                    self.run(seq)
                    
                    /* Only move horizontaly */
                } else {
                    let singleMove = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMove, count: diffX)
                    self.run(moveToDestX)
                }
                
                /* Move Left */
            } else if diffX < 0 {
                self.direction = .left
                
                /* Move forward */
                if diffY > 0 {
                    /* Move horizontaly */
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: -diffX)
                    
                    /* Wait for move horizotaly done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(-diffX)+0.3)) /* 0.3 is buffer */
                    
                    /* Move verticaly */
                    let changeDirect = SKAction.run({ self.direction = .back })
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: diffY)
                    
                    let seq = SKAction.sequence([moveToDestX, wait, changeDirect, moveToDestY])
                    self.run(seq)
                    
                    /* Move backward */
                } else if diffY < 0 {
                    /* Move horizontaly */
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: -diffX)
                    
                    /* Wait for move horizotaly done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(-diffX)+0.3)) /* 0.3 is buffer */
                    
                    /* Move verticaly */
                    let changeDirect = SKAction.run({ self.direction = .front })
                    let singleMove = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMove, count: -diffY)
                    
                    let seq = SKAction.sequence([moveToDestX, wait, changeDirect, moveToDestY])
                    self.run(seq)
                    
                    /* Only move horizontaly */
                } else {
                    let singleMove = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMove, count: -diffX)
                    self.run(moveToDestX)
                }
                /* Only move vertically */
            } else {
                /* Move forward */
                if diffY > 0 {
                    /* Move verticaly */
                    self.direction = .back
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: diffY)
                    self.run(moveToDestY)
                    
                    /* Move backward */
                } else if diffY < 0 {
                    /* Move verticaly */
                    self.direction = .front
                    let singleMove = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMove, count: -diffY)
                    self.run(moveToDestY)
                    /* Stay */
                } else {
                    return
                }
            }

        } else if self.moveDirection == .Vertical {
            /* Move forward */
            if diffY > 0 {
                self.direction = .back
                /* Move right */
                if diffX > 0 {
                    /* Move verticaly */
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: diffY)
                
                    /* Wait for move vertically done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(diffY)+0.3)) /* 0.3 is buffer */
                    
                    /* Move horizontaly */
                    let changeDirect = SKAction.run({ self.direction = .right })
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: diffX)
                   
                    let seq = SKAction.sequence([moveToDestY, wait, changeDirect, moveToDestX])
                    self.run(seq)
                    
                /* Move left */
                } else if diffX < 0 {
                    /* Move verticaly */
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: diffY)
                    
                    /* Wait for move vertically done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(diffY)+0.3)) /* 0.3 is buffer */
                    
                    /* Move horizontaly */
                    let changeDirect = SKAction.run({ self.direction = .left })
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: -diffX)
                    
                    let seq = SKAction.sequence([moveToDestY, wait, changeDirect, moveToDestX])
                    self.run(seq)
                /* Only move vertically */
                } else {
                    /* Move verticaly */
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: diffY)
                    self.run(moveToDestY)
                }
                
            /* Move backward */
            } else if diffY < 0 {
                self.direction = .front
                /* Move right */
                if diffX > 0 {
                    /* Move verticaly */
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: -diffY)
                    
                    /* Wait for move vertically done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(-diffY)+0.3)) /* 0.3 is buffer */
                    
                    /* Move horizontaly */
                    let changeDirect = SKAction.run({ self.direction = .right })
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: diffX)
                    
                    let seq = SKAction.sequence([moveToDestY, wait, changeDirect, moveToDestX])
                    self.run(seq)
                    
                    /* Move left */
                } else if diffX < 0 {
                    /* Move verticaly */
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: -diffY)
                    
                    /* Wait for move vertically done */
                    let wait = SKAction.wait(forDuration: TimeInterval(self.moveSpeed*Double(-diffY)+0.3)) /* 0.3 is buffer */
                    
                    /* Move horizontaly */
                    let changeDirect = SKAction.run({ self.direction = .left })
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: -diffX)
                    
                    let seq = SKAction.sequence([moveToDestY, wait, changeDirect, moveToDestX])
                    self.run(seq)
                
                /* Only move vertically */
                } else {
                    /* Move verticaly */
                    let singleMoveV = SKAction.run({ self.heroSingleMove() })
                    let moveToDestY = SKAction.repeat(singleMoveV, count: -diffY)
                    self.run(moveToDestY)
                }
            /* Only move horizontally */
            } else {
                /* Move right */
                if diffX > 0 {
                    /* Move horizontaly */
                    self.direction = .right
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: diffX)
                    self.run(moveToDestX)
                    
                /* Move left */
                } else if diffX < 0 {
                    /* Move horizontaly */
                    self.direction = .left
                    let singleMoveH = SKAction.run({ self.heroSingleMove() })
                    let moveToDestX = SKAction.repeat(singleMoveH, count: -diffX)
                    self.run(moveToDestX)
                /* Stay */
                } else {
                    return
                }
            }
        }
    }
    
    /* Reset hero position and animation */
    func resetHero() {
        self.direction = .back
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.setTexture()
        self.setMovingAnimation()
    }
    
    /* For tutorial */
    func tutorial0Move(posX: Int, posY: Int, state: TutorialState, waitTime: TimeInterval) {
        /* Get gameScene */
        let gameScene = self.parent as! Tutorial
        
        /* Stop showing move pass */
        gameScene.gridNode.resetMovePath()
        /* Reset hero move direction flag */
        gameScene.gridNode.directionJudgeDoneFlag = false
        /* Move hero to touch location */
        self.heroMoveToDest(posX: posX, posY: posY)
        self.positionX = posX
        self.positionY = posY
        gameScene.gridNode.resetSquareArray(color: "blue")
        let wait = SKAction.wait(forDuration: waitTime)
        let moveState = SKAction.run({
            gameScene.tutorialDone = false
            gameScene.tutorialState = state
        })
        let seq = SKAction.sequence([wait, moveState])
        self.run(seq)
    }
    
    
    
}
