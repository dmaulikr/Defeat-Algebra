//
//  Grid.swift
//  DefeatAlgebra
//
//  Created by yo hanashima on 2017/07/03.
//  Copyright © 2017年 yo hanashima. All rights reserved.
//

import Foundation
import SpriteKit

class GridForTutorial: SKSpriteNode {
    
    /* Grid array dimensions */
    let rows = 12
    let columns = 9
    
    /* Individual cell dimension, auto-calculated */
    var cellWidth:Double = 0
    var cellHeight:Double = 0
    
    var cancellSwipingForTutorialFlag = false
    
    /* Enemy move speed when adding */
    var addingMoveSpeed = 0.5
    
    /* Hero move */
    var beganPos = [Int]()
    var currentPos = [Int]()
    var directionJudgeDoneFlag = false
    
    /* Enemy array */
    var enemyArray = [EnemyForTutorial]()
    var positionEnemyAtGrid = [[Bool]]()
    var numOfTurnEndEnemy = 0
    var turnIndex = 0
    var startPosArray = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    
    /* Flash */
    var flashSpeed: Double = 0.5
    var numOfFlashUp = 3
    
    /* Move & Attack & item setting area for player */
    var squareRedArray = [[SKShapeNode]]() /* for attack */
    var squareBlueArray = [[SKShapeNode]]() /* for move */
    var squarePurpleArray = [[SKShapeNode]]() /* for item */
    
    /* Attack area position */
    var attackAreaPos = [[Int]]()
    
    /* timeBomb */
    var timeBombSetPosArray = [[Int]]()
    var timeBombSetArray = [TimeBomb]()
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /* Enable own touch implementation for this node */
        isUserInteractionEnabled = true
        
        /* Calculate individual cell dimensions */
        cellWidth = Double(size.width) / Double(columns)
        cellHeight = Double(size.height) / Double(rows)
        
        /* Set enemy position origin array */
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Initialize empty column */
            positionEnemyAtGrid.append([])
            
            /* Loop through rows */
            for _ in 0..<rows {
                
                /* Set false at row / column position */
                positionEnemyAtGrid[gridX].append(false)
            }
        }
        
        /* Create enemy startPosArray */
        self.resetEnemyPositon()
        
        /* For display player move area */
        coverGrid()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        print("grid touchBegan")
        /* Get gameScene */
        let gameScene = self.parent as! Tutorial
        
        guard gameScene.pauseFlag == false else { return }
        
        /* Get touch point */
        let touch = touches.first!              // Get the first touch
        let location = touch.location(in: self) // Find the location of that touch in this view
        let nodeAtPoint = atPoint(location)     // Find the node at that location
        
        /* Caclulate grid array position */
        let gridX = Int(Double(location.x) / cellWidth)
        let gridY = Int(Double(location.y) / cellHeight)
        
        switch Tutorial.tutorialPhase {
        case 0:
            switch gameScene.tutorialState {
            case .T1:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T2
                break;
            case .T2:
                /* Move hero to touch location */
                guard nodeAtPoint.name == "activeArea" else { return }
                gameScene.activeHero.tutorial0Move(posX: gridX, posY: gridY, state: .T3, waitTime: 1.0)
                let wait = SKAction.wait(forDuration: 1.0)
                let dispBoots = SKAction.run({
                    /* Boots */
                    let boots = Boots()
                    self.addObjectAtGrid(object: boots, x: 4, y: 6)
                })
                let seq = SKAction.sequence([wait, dispBoots])
                self.run(seq)
                break;
            case .T4:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T5
                break;
            case .T5:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T6
                break;
            case .T6:
                /* Touch red square for active area */
                if nodeAtPoint.name == "activeArea" {
                    /* Reset all */
                    beganPos = []
                    currentPos = []
                    /* Touch hero's position */
                    if gridX == gameScene.activeHero.positionX && gridY == gameScene.activeHero.positionY {
                        /* Display move path */
                        brightCellAsPath(gridX: gridX, gridY: gridY)
                        /* Set touch began position */
                        beganPos = [gridX, gridY]
                        currentPos = beganPos
                    }
                }
                break;
            case .T7:
                guard gridX == gameScene.activeHero.positionX && gridY == gameScene.activeHero.positionY else { return }
                cancellSwipingForTutorialFlag = true
                /* Touch red square for active area */
                if nodeAtPoint.name == "activeArea" {
                    /* Reset all */
                    beganPos = []
                    currentPos = []
                    /* Touch hero's position */
                    if gridX == gameScene.activeHero.positionX && gridY == gameScene.activeHero.positionY {
                        /* Display move path */
                        brightCellAsPath(gridX: gridX, gridY: gridY)
                        /* Set touch began position */
                        beganPos = [gridX, gridY]
                        currentPos = beganPos
                    }
                }
                break;
            case .T9:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T10
                break;
            default:
                break;
            }
            break;
        case 1:
            switch gameScene.tutorialState {
            case .T1:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T2
                break;
            case .T5:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T6
                break;
            case .T6:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T7
                break;
            case .T7:
                if gameScene.tutorial1T7Done {
                    gameScene.tutorialDone = false
                    gameScene.tutorialState = .T8
                }
                break;
            case .T8:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T9
                break;
            case .T9:
                if gameScene.tutorial1T9Done {
                    gameScene.tutorialDone = false
                    gameScene.tutorialState = .T10
                }
                break;
            case .T11:
                if gameScene.tutorial1T11Done {
                    gameScene.tutorialDone = false
                    gameScene.tutorialState = .T12
                }
                break;
            case .T13:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T14
                break;
            case .T15:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T16
                break;
            default:
                break;
            }
            break;
        case 2:
            switch gameScene.tutorialState {
            case .T1:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T2
                break;
            case .T2:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T3
                break;
            case .T3:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T4
                break;
            case .T4:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T5
                break;
            case .T5:
                guard gameScene.gameState == .PlayerTurn else { return }
                
                /* Touch point to move to */
                if gameScene.playerTurnState == .MoveState {
                    
                    /* Touch red square for active area */
                    if nodeAtPoint.name == "activeArea" {
                        
                        /* Reset all */
                        beganPos = []
                        currentPos = []
                        
                        /* Touch hero's position */
                        if gridX == gameScene.activeHero.positionX && gridY == gameScene.activeHero.positionY {
                            /* Display move path */
                            brightCellAsPath(gridX: gridX, gridY: gridY)
                            /* Set touch began position */
                            beganPos = [gridX, gridY]
                            currentPos = beganPos
                        }
                        
                    }
                }
                break;
            case .T8:
                gameScene.tutorialDone = false
                gameScene.tutorialState = .T9
                break;
            default:
                break;
            }
        default:
            break;
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Get gameScene */
        let gameScene = self.parent as! Tutorial
        
        guard gameScene.pauseFlag == false else { return }
        
        /* Get touch point */
        let touch = touches.first!              // Get the first touch
        let location = touch.location(in: self) // Find the location of that touch in this view
        let nodeAtPoint = atPoint(location)     // Find the node at that location
        
        /* Caclulate grid array position */
        let gridX = Int(Double(location.x) / cellWidth)
        let gridY = Int(Double(location.y) / cellHeight)
        
        switch Tutorial.tutorialPhase {
        case 0:
            if gameScene.tutorialState == .T6 || gameScene.tutorialState == .T7 || gameScene.tutorialState == .T8 {
                if nodeAtPoint.name == "activeArea" {
                    if beganPos.count > 0 {
                        if beganPos[0] == gameScene.activeHero.positionX && beganPos[1] == gameScene.activeHero.positionY {
                            
                            let nextPos = [gridX, gridY]
                            
                            /* Touching position moves to next cell */
                            if nextPos != currentPos {
                                
                                /* Make sure direction judge is excute at first move */
                                if directionJudgeDoneFlag == false {
                                    directionJudgeDoneFlag = true
                                    
                                    /* Finger move horizontally */
                                    if nextPos[0] != beganPos[0] {
                                        gameScene.activeHero.moveDirection = .Horizontal
                                        dispMovePath(start: beganPos, dest: nextPos)
                                        currentPos = nextPos
                                        /* Finger move vertically */
                                    } else if nextPos[1] != beganPos[1] {
                                        gameScene.activeHero.moveDirection = .Vertical
                                        dispMovePath(start: beganPos, dest: nextPos)
                                        currentPos = nextPos
                                    }
                                } else {
                                    dispMovePath(start: beganPos, dest: nextPos)
                                    currentPos = nextPos
                                }
                                /* In case backing to began position */
                            } else if nextPos == beganPos {
                                currentPos = nextPos
                                brightCellAsPath(gridX: beganPos[0], gridY: beganPos[1])
                                
                                directionJudgeDoneFlag = false
                            }
                        }
                    }
                } else {
                    directionJudgeDoneFlag = false
                    resetMovePath()
                }
            }
            break;
        case 2:
            switch gameScene.tutorialState {
            case .T5:
                guard gameScene.gameState == .PlayerTurn else { return }
                
                /* Touch ends on active area */
                if nodeAtPoint.name == "activeArea" {
                    
                    if beganPos.count > 0 {
                        if beganPos[0] == gameScene.activeHero.positionX && beganPos[1] == gameScene.activeHero.positionY {
                            
                            let nextPos = [gridX, gridY]
                            
                            /* Touching position moves to next cell */
                            if nextPos != currentPos {
                                
                                /* Make sure direction judge is excute at first move */
                                if directionJudgeDoneFlag == false {
                                    directionJudgeDoneFlag = true
                                    
                                    /* Finger move horizontally */
                                    if nextPos[0] != beganPos[0] {
                                        gameScene.activeHero.moveDirection = .Horizontal
                                        dispMovePath(start: beganPos, dest: nextPos)
                                        currentPos = nextPos
                                        /* Finger move vertically */
                                    } else if nextPos[1] != beganPos[1] {
                                        gameScene.activeHero.moveDirection = .Vertical
                                        dispMovePath(start: beganPos, dest: nextPos)
                                        currentPos = nextPos
                                    }
                                } else {
                                    dispMovePath(start: beganPos, dest: nextPos)
                                    currentPos = nextPos
                                }
                                /* In case backing to began position */
                            } else if nextPos == beganPos {
                                currentPos = nextPos
                                brightCellAsPath(gridX: beganPos[0], gridY: beganPos[1])
                                
                                directionJudgeDoneFlag = false
                            }
                        }
                    }
                } else {
                    directionJudgeDoneFlag = false
                    resetMovePath()
                }

                break;
            default:
                break;
            }
        default:
            break;
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* Get gameScene */
        let gameScene = self.parent as! Tutorial
        
        guard gameScene.pauseFlag == false else { return }
        
        /* Get touch point */
        let touch = touches.first!              // Get the first touch
        let location = touch.location(in: self) // Find the location of that touch in this view
        let nodeAtPoint = atPoint(location)     // Find the node at that location
        
        /* Caclulate grid array position */
        let gridX = Int(Double(location.x) / cellWidth)
        let gridY = Int(Double(location.y) / cellHeight)
        
        switch Tutorial.tutorialPhase {
        case 0:
            switch gameScene.tutorialState {
            case .T3:
                /* Move hero to touch location */
                guard nodeAtPoint.name == "activeArea" else { return }
                if gridX == 4 && gridY == 6 {
                    /* Stop showing move pass */
                    self.resetMovePath()
                    /* Reset hero move direction flag */
                    self.directionJudgeDoneFlag = false
                    resetSquareArray(color: "blue")
                    /* Move hero to touch location */
                    gameScene.activeHero.heroMoveToDest(posX: gridX, posY: gridY)
                    gameScene.activeHero.positionX = gridX
                    gameScene.activeHero.positionY = gridY
                } else {
                    gameScene.activeHero.tutorial0Move(posX: gridX, posY: gridY, state: .T3, waitTime: 1.0)
                }
                break;
            case .T6:
                if gridX == gameScene.activeHero.positionX+1 && gridY == gameScene.activeHero.positionY-1 {
                    if let node = gameScene.childNode(withName: "movingPoint") {
                        node.removeFromParent()
                    }
                    gameScene.removeAllActions()
                    gameScene.activeHero.tutorial0Move(posX: gridX, posY: gridY, state: .T7, waitTime: 1.5)
                } else {
                    /* Stop showing move pass */
                    resetMovePath()
                    return
                }
                break;
            case .T7:
                guard cancellSwipingForTutorialFlag else { return }
                if nodeAtPoint.name == "activeArea" {
                    cancellSwipingForTutorialFlag = false
                    resetMovePath()
                    return
                } else {
                    if let node = gameScene.childNode(withName: "movingPoint") {
                        node.removeFromParent()
                    }
                    gameScene.removeAllActions()
                    gameScene.tutorialState = .T8
                    gameScene.tutorialDone = false
                }
                break;
            case .T8:
                guard gridX == gameScene.activeHero.positionX && gridY == gameScene.activeHero.positionY else { return }
                gameScene.activeHero.tutorial0Move(posX: gridX, posY: gridY, state: .T9, waitTime: 1.0)
            default:
                break;
            }
            break;
        case 2:
            switch gameScene.tutorialState {
            case .T5:
                guard gameScene.gameState == .PlayerTurn else { return }
                               
                /* Touch ends on active area */
                if nodeAtPoint.name == "activeArea" {
                    
                    /* Touch point to move to */
                    if gameScene.playerTurnState == .MoveState {
                        
                        /* Stop showing move pass */
                        resetMovePath()
                        
                        /* Reset hero move direction flag */
                        directionJudgeDoneFlag = false
                        
                        /* On hero moving flag */
                        gameScene.heroMovingFlag = true
                        
                        /* On moveDoneFlad */
                        gameScene.activeHero.moveDoneFlag = true
                        
                        /* Move hero to touch location */
                        gameScene.activeHero.heroMoveToDest(posX: gridX, posY: gridY)
                        
                        /* Reset move area */
                        self.resetSquareArray(color: "blue")
                        
                        /* Keep track hero position */
                        gameScene.activeHero.positionX = gridX
                        gameScene.activeHero.positionY = gridY
                        
                        /* Move next state */
                        let wait = SKAction.wait(forDuration: gameScene.turnEndWait)
                        let nextHero = SKAction.run({
                            /* Reset hero animation to back */
                            gameScene.activeHero.resetHero()
                            
                            gameScene.heroMovingFlag = false
                            
                            /* All hero turn end */
                            if gameScene.numOfTurnDoneHero >= gameScene.heroArray.count-1 {
                                gameScene.playerTurnState = .TurnEnd
                            } else {
                                gameScene.numOfTurnDoneHero += 1
                                gameScene.activeHero = gameScene.heroArray[gameScene.numOfTurnDoneHero]
                            }
                        })
                        let seq = SKAction.sequence([wait, nextHero])
                        self.run(seq)
                        
                        /* Touch point to attack to */
                    } else if gameScene.playerTurnState == .AttackState {
                        
                        guard gameScene.heroMovingFlag == false else { return }
                        
                        /* Remove attack area square */
                        self.resetSquareArray(color: "red")
                        
                        /* Touch red square for active area */
                        if nodeAtPoint.name == "activeArea" {
                            
                            /* Set direction of hero */
                            gameScene.activeHero.setHeroDirection(posX: gridX, posY: gridY)
                            
                            /* Sword attack */
                            if gameScene.activeHero.attackType == 0 {
                                gameScene.activeHero.setSwordAnimation()
                                
                                /* If hitting enemy! */
                                if self.positionEnemyAtGrid[gridX][gridY] {
                                    let waitAni = SKAction.wait(forDuration: 1.0)
                                    let removeEnemy = SKAction.run({
                                        /* Look for the enemy to destroy */
                                        for enemy in self.enemyArray {
                                            if enemy.positionX == gridX && enemy.positionY == gridY {
                                                /* Effect */
                                                self.enemyDestroyEffect(enemy: enemy)
                                                
                                                /* Enemy */
                                                let waitEffectRemove = SKAction.wait(forDuration: 1.0)
                                                let removeEnemy = SKAction.run({ enemy.removeFromParent() })
                                                let seqEnemy = SKAction.sequence([waitEffectRemove, removeEnemy])
                                                self.run(seqEnemy)
                                                enemy.aliveFlag = false
                                                /* Count defeated enemy */
                                                gameScene.totalNumOfEnemy -= 1
                                            }
                                        }
                                    })
                                    let seq = SKAction.sequence([waitAni, removeEnemy])
                                    self.run(seq)
                                }
                            }
                            
                            /* Back to MoveState */
                            gameScene.activeHero.attackDoneFlag = true
                            let wait = SKAction.wait(forDuration: gameScene.turnEndWait+1.0) /* 1.0 is wait time for animation */
                            let moveState = SKAction.run({
                                /* Reset hero animation to back */
                                gameScene.activeHero.resetHero()
                                gameScene.playerTurnState = .MoveState
                            })
                            let seq = SKAction.sequence([wait, moveState])
                            self.run(seq)
                            
                            /* If touch anywhere but activeArea, back to MoveState  */
                        } else {
                            gameScene.playerTurnState = .MoveState
                        }
                        
                        /* Touch position to use item at */
                    } else if gameScene.playerTurnState == .UsingItem {
                        
                        /* Use timeBomb */
                        if gameScene.itemType == .timeBomb {
                            
                            /* Store position of set timeBomb */
                            self.timeBombSetPosArray.append([gridX, gridY])
                            
                            /* Set timeBomb at the location you touch */
                            let timeBomb = TimeBomb()
                            timeBomb.texture = SKTexture(imageNamed: "timeBombToSet")
                            /* Make sure not to collide to hero */
                            timeBomb.physicsBody = nil
                            self.timeBombSetArray.append(timeBomb)
                            self.addObjectAtGrid(object: timeBomb, x: gridX, y: gridY)
                            
                            /* Remove item active areas */
                            self.resetSquareArray(color: "purple")
                            /* Reset item type */
                            gameScene.itemType = .None
                            /* Set item area cover */
                            gameScene.itemAreaCover.isHidden = false
                            
                            /* Back to MoveState */
                            gameScene.playerTurnState = .MoveState
                            
                            //                    print("Used item index is \(gameScene.usingItemIndex)")
                            /* Remove used itemIcon from item array and Scene */
                            gameScene.resetDisplayItem(index: gameScene.usingItemIndex)
                        }
                    }
                }
                break;
            case .T7:
                /* Get gameScene */
                let gameScene = self.parent as! Tutorial
                
                /* Get touch point */
                let touch = touches.first!              // Get the first touch
                let location = touch.location(in: self) // Find the location of that touch in this view
                let nodeAtPoint = atPoint(location)     // Find the node at that location
                
                /* Caclulate grid array position */
                let gridX = Int(Double(location.x) / cellWidth)
                let gridY = Int(Double(location.y) / cellHeight)
                
                if gridX == enemyArray[0].positionX && gridY == enemyArray[0].positionY {
                    /* Remove attack area square */
                    self.resetSquareArray(color: "red")
                    
                    /* Set direction of hero */
                    gameScene.activeHero.setHeroDirection(posX: gridX, posY: gridY)
                    
                    /* Sword attack */
                    gameScene.activeHero.setSwordAnimation()
                    
                    /* If hitting enemy! */
                    if self.positionEnemyAtGrid[gridX][gridY] {
                        let waitAni = SKAction.wait(forDuration: 1.0)
                        let removeEnemy = SKAction.run({
                            /* Look for the enemy to destroy */
                            for enemy in self.enemyArray {
                                if enemy.positionX == gridX && enemy.positionY == gridY {
                                    /* Effect */
                                    self.enemyDestroyEffect(enemy: enemy)
                                    
                                    /* Enemy */
                                    let waitEffectRemove = SKAction.wait(forDuration: 1.0)
                                    let removeEnemy = SKAction.run({ enemy.removeFromParent() })
                                    let seqEnemy = SKAction.sequence([waitEffectRemove, removeEnemy])
                                    self.run(seqEnemy)
                                    enemy.aliveFlag = false
                                    /* Count defeated enemy */
                                    gameScene.totalNumOfEnemy -= 1
                                }
                            }
                        })
                        let seq = SKAction.sequence([waitAni, removeEnemy])
                        self.run(seq)
                        
                        /* Move State */
                        gameScene.activeHero.attackDoneFlag = true
                        let wait = SKAction.wait(forDuration: gameScene.turnEndWait+1.0) /* 1.0 is wait time for animation */
                        let moveState = SKAction.run({
                            /* Reset hero animation to back */
                            gameScene.activeHero.resetHero()
                            gameScene.tutorialDone = false
                            gameScene.tutorialState = .T8
                        })
                        let seq2 = SKAction.sequence([wait, moveState])
                        self.run(seq2)
                    }
                }
                break;
            default:
                break;
            }
        default:
            break;
        }
    }
    
    func resetStartPosArray() {
        for i in 0..<columns {
            self.startPosArray.append(i)
        }
    }
    
    /* Add initial enemy */
    func addInitialEnemyAtGrid(enemyPosArray: [[Int]], variableExpressionSource: [[Int]]) {
        /* Add a new enemy at grid position*/
        
        /* Get gameScene */
        let gameScene = self.parent as! Tutorial
        
        let punchIntervalArray = [2,3,3]
        
        for (i, posArray) in enemyPosArray.enumerated() {
            /* New enemy object */
            let enemy = EnemyForTutorial(variableExpressionSource: variableExpressionSource, interval: punchIntervalArray[i])
            
            enemy.indexOfArray = i
            
            /* Attach variable expression */
            enemy.setVariableExpressionLabel(text: enemy.variableExpressionForLabel)
            
            /* Set direction of enemy */
            enemy.direction = .front
            enemy.setMovingAnimation()
            
            /* Set position on screen */
            /* Enemy come to grid from out of it */
            let startPosition = posArray[0]
            
            /* Keep track enemy position */
            enemy.positionX = startPosition
            enemy.positionY = posArray[1]
            
            /* Calculate gap between top of grid and gameScene */
            let gridPosition = CGPoint(x: CGFloat((Double(startPosition)+0.5)*cellWidth), y: gameScene.topGap+self.size.height)
            enemy.position = gridPosition
            
            /* Set enemy's move distance when showing up */
            let startMoveDistance = Double(gameScene.topGap)+self.cellHeight*(Double(11-posArray[1])+0.5)
            
            /* Calculate relative duration with distance */
            let startDulation = TimeInterval(startMoveDistance/Double(self.cellHeight)*self.addingMoveSpeed)
            
            /* Move enemy for startMoveDistance */
            let move = SKAction.moveBy(x: 0, y: -CGFloat(startMoveDistance), duration: startDulation)
            enemy.run(move)
            
            /* Add enemy to grid node */
            addChild(enemy)
            
            /* Add enemy to enemyArray */
            self.enemyArray.append(enemy)
        }
    }
    
    func flashGrid(labelNode: SKLabelNode) -> Int {
        let numOfFlash = Int(arc4random_uniform(2)+1)
        
        /* Set flash animation */
        let fadeInColorlize = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: TimeInterval(self.flashSpeed/4))
        let wait = SKAction.wait(forDuration: TimeInterval(self.flashSpeed/4))
        let fadeOutColorlize = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: TimeInterval(self.flashSpeed/4))
        let seqFlash = SKAction.sequence([fadeInColorlize, wait, fadeOutColorlize, wait])
        let flash = SKAction.repeat(seqFlash, count: numOfFlash)
        self.run(flash)
        
        /* Display the number of flash */
        let wholeWait = SKAction.wait(forDuration: TimeInterval(self.flashSpeed*Double(numOfFlash)))
        let display = SKAction.run({ labelNode.text = String(numOfFlash) })
        let seq = SKAction.sequence([wholeWait, display])
        self.run(seq)
        
        return numOfFlash
    }
    
    /* Add a new object at grid position*/
    func addObjectAtGrid(object: SKSpriteNode, x: Int, y: Int) {
        /* Calculate position on screen */
        let gridPosition = CGPoint(x: (Double(x)+0.5)*cellWidth, y: (Double(y)+0.5)*cellHeight)
        object.position = gridPosition
        object.zPosition = 3
        
        /* Add timeBomb to grid node */
        addChild(object)
    }
    
    /* Reset enemy position array */
    func resetEnemyPositon() {
        for x in 0..<columns {
            /* Loop through rows */
            for y in 0..<rows {
                positionEnemyAtGrid[x][y] = false
            }
        }
    }
    
    /* Update enemy position at grid */
    func updateEnemyPositon() {
        for enemy in self.enemyArray {
            self.positionEnemyAtGrid[enemy.positionX][enemy.positionY] = true
        }
    }
    
    /* Show area where player can move */
    func showMoveArea(posX: Int, posY: Int, moveLevel: Int) {
        /* Show up red square according to move level */
        switch moveLevel {
        case 1:
            for gridX in posX-1...posX+1 {
                /* Make sure inside the grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    squareBlueArray[gridX][posY].isHidden = false
                }
            }
            for gridY in posY-1...posY+1 {
                /* Make sure inside the grid */
                if gridY >= 0 && gridY <= self.rows-1 {
                    squareBlueArray[posX][gridY].isHidden = false
                }
            }
        case 2:
            for gridX in posX-2...posX+2 {
                /* Make sure inside the grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    squareBlueArray[gridX][posY].isHidden = false
                }
            }
            for gridY in posY-2...posY+2 {
                /* Make sure inside the grid */
                if gridY >= 0 && gridY <= self.rows-1 {
                    squareBlueArray[posX][gridY].isHidden = false
                }
            }
            for gridX in posX-1...posX+1 {
                /* Make sure within grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    for gridY in posY-1...posY+1 {
                        /* Make sure within grid */
                        if gridY >= 0 && gridY <= self.rows-1 {
                            squareBlueArray[gridX][gridY].isHidden = false
                        }
                    }
                }
            }
        case 3:
            for gridX in posX-3...posX+3 {
                /* Make sure inside the grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    squareBlueArray[gridX][posY].isHidden = false
                }
            }
            for gridY in posY-3...posY+3 {
                /* Make sure inside the grid */
                if gridY >= 0 && gridY <= self.rows-1 {
                    squareBlueArray[posX][gridY].isHidden = false
                }
            }
            for gridX in posX-2...posX+2 {
                /* Make sure within grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    for gridY in posY-2...posY+2 {
                        /* Make sure within grid */
                        if gridY >= 0 && gridY <= self.rows-1 {
                            /* Remove corner */
                            if gridX == posX-2 && gridY == posY-2 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else if gridX == posX-2 && gridY == posY+2 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else if gridX == posX+2 && gridY == posY-2 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else if gridX == posX+2 && gridY == posY+2 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else {
                                squareBlueArray[gridX][gridY].isHidden = false
                            }
                            
                        }
                    }
                }
            }
        case 4:
            for gridX in posX-4...posX+4 {
                /* Make sure inside the grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    squareBlueArray[gridX][posY].isHidden = false
                }
            }
            for gridY in posY-4...posY+4 {
                /* Make sure inside the grid */
                if gridY >= 0 && gridY <= self.rows-1 {
                    squareBlueArray[posX][gridY].isHidden = false
                }
            }
            for gridX in posX-3...posX+3 {
                /* Make sure within grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    for gridY in posY-3...posY+3 {
                        /* Make sure within grid */
                        if gridY >= 0 && gridY <= self.rows-1 {
                            /* Remove corner */
                            if gridX == posX-3 && gridY == posY-3 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else if gridX == posX-3 && gridY == posY+3 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else if gridX == posX+3 && gridY == posY-3 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else if gridX == posX+3 && gridY == posY+3 {
                                squareBlueArray[gridX][gridY].isHidden = true
                            } else {
                                squareBlueArray[gridX][gridY].isHidden = false
                            }
                            
                        }
                    }
                }
            }
        default:
            break;
        }
    }
    
    /* Show attack area */
    func showAttackArea(posX: Int, posY: Int, attackType: Int) {
        /* Show up red square according to move level */
        switch attackType {
        case 0:
            for gridX in posX-1...posX+1 {
                /* Make sure inside the grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    /* Remove hero position */
                    if gridX != posX {
                        squareRedArray[gridX][posY].isHidden = false
                    }
                }
            }
            for gridY in posY-1...posY+1 {
                /* Make sure inside the grid */
                if gridY >= 0 && gridY <= self.rows-1 {
                    /* Remove hero position */
                    if gridY != posY {
                        squareRedArray[posX][gridY].isHidden = false
                    }
                }
            }
        case 1:
            for gridX in posX-2...posX+2 {
                /* Make sure inside the grid */
                if gridX >= 0 && gridX <= self.columns-1 {
                    /* Remove hero position */
                    if gridX != posX {
                        squareRedArray[gridX][posY].isHidden = false
                    }
                }
            }
            for gridY in posY-2...posY+2 {
                /* Make sure inside the grid */
                if gridY >= 0 && gridY <= self.rows-1 {
                    /* Remove hero position */
                    if gridY != posY {
                        squareRedArray[posX][gridY].isHidden = false
                    }
                }
            }
        default:
            break;
        }
        
    }
    
    /*== Set effect when enemy destroyed ==*/
    func enemyDestroyEffect(enemy: EnemyForTutorial) {
        /* Load our particle effect */
        let particles = SKEmitterNode(fileNamed: "DestroyEnemy")!
        particles.position = CGPoint(x: enemy.position.x, y: enemy.position.y-20)
        /* Add particles to scene */
        self.addChild(particles)
        let waitEffectRemove = SKAction.wait(forDuration: 1.0)
        let removeParticles = SKAction.removeFromParent()
        let seqEffect = SKAction.sequence([waitEffectRemove, removeParticles])
        particles.run(seqEffect)
    }
    
    /* Show timeBomb setting area */
    func showtimeBombSettingArea() {
        for gridX in 0..<self.columns {
            for gridY in 1..<self.rows-1 {
                self.squarePurpleArray[gridX][gridY].isHidden = false
            }
        }
    }
    
    /* Show timeBomb setting area */
    func showWallSettingArea() {
        for gridX in 0..<self.columns {
            for gridY in 0..<self.rows-1 {
                self.squarePurpleArray[gridX][gridY].isHidden = false
                if gridX == self.columns-1 && gridY == self.rows-1 {
                    for enemy in self.enemyArray {
                        self.squarePurpleArray[enemy.positionX][enemy.positionY].isHidden = true
                    }
                }
            }
        }
    }
    
    /* Reset squareArray */
    func resetSquareArray(color: String) {
        switch color {
        case "red":
            for x in 0..<columns {
                /* Loop through rows */
                for y in 0..<rows {
                    squareRedArray[x][y].isHidden = true
                }
            }
        case "blue":
            for x in 0..<columns {
                /* Loop through rows */
                for y in 0..<rows {
                    squareBlueArray[x][y].isHidden = true
                }
            }
        case "purple":
            for x in 0..<columns {
                /* Loop through rows */
                for y in 0..<rows {
                    squarePurpleArray[x][y].isHidden = true
                }
            }
        default:
            break;
        }
        
    }
    
    func coverGrid() {
        /* Populate the grid with creatures */
        
        /* Red square */
        /* Loop through columns */
        for gridX in 0..<columns {
            /* Initialize empty column */
            squareRedArray.append([])
            /* Loop through rows */
            for gridY in 0..<rows {
                /* Createa new creature at row / column position */
                addSquareAtGrid(x:gridX, y:gridY, color: UIColor.red)
            }
        }
        
        /* Blue square */
        /* Loop through columns */
        for gridX in 0..<columns {
            /* Initialize empty column */
            squareBlueArray.append([])
            /* Loop through rows */
            for gridY in 0..<rows {
                /* Createa new creature at row / column position */
                addSquareAtGrid(x:gridX, y:gridY, color: UIColor.blue)
            }
        }
        
        /* purple square */
        /* Loop through columns */
        for gridX in 0..<columns {
            /* Initialize empty column */
            squarePurpleArray.append([])
            /* Loop through rows */
            for gridY in 0..<rows {
                /* Createa new creature at row / column position */
                addSquareAtGrid(x:gridX, y:gridY, color: UIColor.purple)
            }
        }
    }
    
    func addSquareAtGrid(x: Int, y: Int, color: UIColor) {
        /* Add a new creature at grid position*/
        
        /* Create square */
        let square = SKShapeNode(rectOf: CGSize(width: self.cellWidth, height: cellHeight))
        square.fillColor = color
        square.alpha = 0.4
        square.zPosition = 100
        square.name = "activeArea"
        
        /* Calculate position on screen */
        let gridPosition = CGPoint(x: (Double(x)+0.5)*cellWidth, y: (Double(y)+0.5)*cellHeight)
        square.position = gridPosition
        
        /* Set default isAlive */
        square.isHidden = true
        
        /* Add creature to grid node */
        addChild(square)
        
        /* Add creature to grid array */
        switch color {
        case UIColor.red:
            squareRedArray[x].append(square)
        case UIColor.blue:
            squareBlueArray[x].append(square)
        case UIColor.purple:
            squarePurpleArray[x].append(square)
        default:
            break;
        }
    }
    
    /* Display move path */
    func dispMovePath(start: [Int], dest: [Int]) {
        /* Get gameScene */
        let gameScene = self.parent as! Tutorial
        
        /* Reset display path */
        resetMovePath()
        
        /* Calculate difference between beganPos and destination */
        let diffX = dest[0] - start[0]
        let diffY = dest[1] - start[1]
        
        switch gameScene.activeHero.moveDirection {
            /* Set move path horizontal → vertical */
        case .Horizontal:
            if diffY == 0 {
                
                /* To right */
                if diffX > 0 {
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: start, destPos: dest)
                }
                /* To left */
                if diffX < 0 {
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: dest, destPos: start)
                }
            } else if diffX == 0 {
                
                /* To up direction */
                if diffY > 0 {
                    /* Cololize cell as a move path */
                    brightColumnlAsPath(startPos: start, destPos: dest)
                }
                /* To down direction */
                if diffY < 0 {
                    /* Cololize cell as a move path */
                    brightColumnlAsPath(startPos: dest, destPos: start)
                }
            } else if diffY > 0 {
                
                /* To right up direction */
                if diffX > 0 {
                    let viaPos = [dest[0], start[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: start, destPos: viaPos)
                    brightColumnlAsPath(startPos: viaPos, destPos: dest)
                }
                /* To left up direction */
                if diffX < 0 {
                    let viaPos = [dest[0], start[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: viaPos, destPos: start)
                    brightColumnlAsPath(startPos: viaPos, destPos: dest)
                }
            } else if diffY < 0 {
                
                /* To right down direction */
                if diffX > 0 {
                    let viaPos = [dest[0], start[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: start, destPos: viaPos)
                    brightColumnlAsPath(startPos: dest, destPos: viaPos)
                }
                /* To left down direction */
                if diffX < 0 {
                    let viaPos = [dest[0], start[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: viaPos, destPos: start)
                    brightColumnlAsPath(startPos: dest, destPos: viaPos)
                }
            }
            break;
            /* Set move path horizontal → vertical */
        case .Vertical:
            if diffX == 0 {
                /* To up */
                if diffY > 0 {
                    /* Cololize cell as a move path */
                    brightColumnlAsPath(startPos: start, destPos: dest)
                }
                /* To down */
                if diffY < 0 {
                    /* Cololize cell as a move path */
                    brightColumnlAsPath(startPos: dest, destPos: start)
                }
            } else if diffY == 0 {
                /* To right direction */
                if diffX > 0 {
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: start, destPos: dest)
                }
                /* To left direction */
                if diffX < 0 {
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: dest, destPos: start)
                }
            } else if diffY > 0 {
                /* To right up direction */
                if diffX > 0 {
                    let viaPos = [start[0], dest[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: viaPos, destPos: dest)
                    brightColumnlAsPath(startPos: start, destPos: viaPos)
                }
                /* To left up direction */
                if diffX < 0 {
                    let viaPos = [start[0], dest[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: dest, destPos: viaPos)
                    brightColumnlAsPath(startPos: start, destPos: viaPos)
                }
            } else if diffY < 0 {
                /* To right down direction */
                if diffX > 0 {
                    let viaPos = [start[0], dest[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: viaPos, destPos: dest)
                    brightColumnlAsPath(startPos: viaPos, destPos: start)
                }
                /* To left down direction */
                if diffX < 0 {
                    let viaPos = [start[0], dest[1]]
                    /* Cololize cell as a move path */
                    brightRowAsPath(startPos: dest, destPos: viaPos)
                    brightColumnlAsPath(startPos: viaPos, destPos: start)
                }
            }
            break;
        }
    }
    
    func brightRowAsPath(startPos: [Int], destPos: [Int]) {
        for i in startPos[0]...destPos[0] {
            brightCellAsPath(gridX: i, gridY: startPos[1])
        }
    }
    
    func brightColumnlAsPath(startPos: [Int], destPos: [Int]) {
        for i in startPos[1]...destPos[1] {
            brightCellAsPath(gridX: startPos[0], gridY: i)
        }
    }
    
    func brightCellAsPath(gridX: Int, gridY: Int) {
        squareBlueArray[gridX][gridY].alpha = 0.8
    }
    
    /* Reset move path */
    func resetMovePath() {
        for gridX in 0..<self.columns {
            for gridY in 0..<self.rows-1 {
                self.squareBlueArray[gridX][gridY].alpha = 0.4
            }
        }
    }
    
    
}

