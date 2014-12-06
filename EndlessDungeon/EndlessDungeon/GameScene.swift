//
//  GameScene.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/21/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    let cellSize : Int = 30
    var dungeon : Dungeon!
    var lightNode : SKLightNode!
    var lastTileSprite : SKSpriteNode!
    
    //Stuff for running the game
    var initiative : [Character]!
    var initiativeTurn : Int = 0
    var currentInitiativeIndex : Int = 0
    var usedMinorAction : Bool = false
    var usedMoveAction : Bool = false
    var distanceMoved : Int = 0
    var usedStandardAction : Bool = false
    //
    
    //Gestures
    var swipeRight : UISwipeGestureRecognizer!
    var swipeLeft : UISwipeGestureRecognizer!
    var swipeUp : UISwipeGestureRecognizer!
    var swipeDown : UISwipeGestureRecognizer!
    var longTouch : UILongPressGestureRecognizer!
    var pinchGesture : UIPinchGestureRecognizer!
    var edgePanGesture : UIScreenEdgePanGestureRecognizer!
    //
    
    override func didMoveToView(view: SKView)
    {
        //Set up controls
        swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        longTouch = UILongPressGestureRecognizer(target: self, action: Selector("interactWithCell:"))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: Selector("openInventory:"))
        edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: ("endTurn:"))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        edgePanGesture.edges = UIRectEdge.Right
        
        self.view?.addGestureRecognizer(swipeRight)
        self.view?.addGestureRecognizer(swipeLeft)
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
        self.view?.addGestureRecognizer(longTouch)
        self.view?.addGestureRecognizer(pinchGesture)
        self.view?.addGestureRecognizer(edgePanGesture)
        //
        
        //Create dungeon
        dungeon = Dungeon.sharedInstance.createDungeon(self.view?.frame, cSize: cellSize, thePlayer: Player(playerName: "Player 1", level: 1))
        
        //Add views and hide some for later use by the player
        //Container
        self.view?.addSubview(dungeon.containerViewController.view)
        dungeon.containerViewController.view.hidden = true
        //Inventory
        self.view?.addSubview(dungeon.characterEquipmentViewController.view)
        dungeon.characterEquipmentViewController.view.hidden = true
        //

        //Draw the entrance
        lastTileSprite = dungeon.entranceTile.tileSprite
        self.addChild(dungeon.entranceTile.tileSprite)
        self.addChild(dungeon.player.sprite)
        
        beginEncounter()
    }
    
    func beginEncounter()
    {
        //roll initiative
        initiative = dungeon.rollInitiativeForCurrentTile()
        //Set to -1 so when it enters next character turn method it starts the first players turn
        initiativeTurn = -1
        
        //Resets all variables and starts enemy's turn if they go first
        nextCharacterTurn()
    }
    
    func nextCharacterTurn()
    {
        initiativeTurn = (initiativeTurn + 1) % initiative.count
        
        debugPrintln(initiative[initiativeTurn].name + " turn")
        
        usedStandardAction = false
        usedMoveAction = false
        usedMinorAction = false
        distanceMoved = 0
        
        //If it is not the players turn, disable the controls, else enable them
        if(!(initiative[initiativeTurn] is Player))
        {
            setGesturesEnabled(false)
            
            //Begin enemy turn
            executeEnemyTurn()
        }
        else
        {
            setGesturesEnabled(true)
        }
    }
    
    func endEncounter()
    {
        
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        if(usedStandardAction && usedMoveAction)// && usedMinorAction)
        {
            nextCharacterTurn()
        }
    }
    
    func movePlayer(gestureInfo : UISwipeGestureRecognizer)
    {
        if(usedMoveAction)
        {
            debugPrintln("Already completed your move action")
            return
        }
        
        var nextTileSprite : SKSpriteNode!
        
        switch gestureInfo.direction
        {
            case UISwipeGestureRecognizerDirection.Up:
                nextTileSprite = dungeon.movePlayerInDirection(.North)
            
            case UISwipeGestureRecognizerDirection.Down:
                nextTileSprite = dungeon.movePlayerInDirection(.South)
            
            case UISwipeGestureRecognizerDirection.Right:
                nextTileSprite = dungeon.movePlayerInDirection(.East)
            
            case UISwipeGestureRecognizerDirection.Left:
                nextTileSprite = dungeon.movePlayerInDirection(.West)
            
            default:
                debugPrintln("Not sure which direction you swiped... are you a wizard?")
        }
        
        //Close any open container
        dungeon.containerViewController.close()
        
        //Moves to new tile
        if nextTileSprite != nil
        {
            self.removeChildrenInArray([lastTileSprite])
            self.addChild(nextTileSprite)
            lastTileSprite = nextTileSprite
            
            beginEncounter()
        }
        
        //Update move action status
        //Change this later to allow diagonal movement
        distanceMoved += 5
        
        if(dungeon.player.speed <= distanceMoved)
        {
            usedMoveAction = true
        }
    }
    
    func interactWithCell(gestureInfo : UILongPressGestureRecognizer)
    {
        if(gestureInfo.state == UIGestureRecognizerState.Began)
        {
            var cell : Cell = dungeon.cellAtScreenLocation(mirroredPosition(gestureInfo.locationInView(self.view), xMirror: false, yMirror: true))!
            
            var character : Character? = cell.characterInCell
            var openable : Openable? = cell.openableInCell
            var item : Item? = cell.itemInCell
            
            //If this cell has an attackable character
            if(character != nil)
            {
                //If the character is incapacitated
                if(character!.unconscious || character!.dead)
                {
                    //If you are within range, then loot him
                    if(Dungeon.distanceBetweenCells(dungeon.cellAtScreenLocation(dungeon.player.sprite.position)!, toCell: cell) <= 1)
                    {
                        if(character!.inventory.isOpen)
                        {
                            character!.inventory.close()
                        }
                        else
                        {
                            character!.inventory.open()
                        }
                    }
                }
                //If the character is still alive and hostile
                else
                {
                    //Don't attack yourself
                    if(!(character! is Player))
                    {
                        //Attack character
                        dungeon.attackCharacter(dungeon.player, defender: character!)
                        
                        //If you have completed part of your move action, end it when attacking
                        if(distanceMoved > 0)
                        {
                            usedMoveAction = true
                        }
                        
                        usedStandardAction = true
                    }
                    
                    //Check for unconscious or death
                    if(character!.unconscious || character!.dead)
                    {
                        //Kill character
                        character?.sprite.color = UIColor.redColor()
                    }
                }
            }
            //If this cell has some sort of openable
            else if(openable != nil)
            {
                if(Dungeon.distanceBetweenCells(dungeon.cellAtScreenLocation(dungeon.player.sprite.position)!, toCell: cell) <= 1)
                {
                    //dungeon.player.openOpenable(openable!)
                    if(!openable!.isOpen)
                    {
                        openable!.open()
                    }
                    else
                    {
                        openable!.close()
                    }
                }
            }
            else if(item != nil)
            {
                
            }
            else
            {
                debugPrintln("This is an empty cell")
            }
        }
    }
    
    func endTurn(gesture : UIScreenEdgePanGestureRecognizer)
    {
        if(gesture.state == UIGestureRecognizerState.Ended)
        {
            usedStandardAction = true
            usedMoveAction = true
            usedMinorAction = true
        
            debugPrintln("Ended your turn")
        }
    }
    
    func executeEnemyTurn()
    {
        //Start with a basic depth-first search to get within range and then attack the player
        //Update to something more intelligent later
        var enemy : NPCharacter = initiative[initiativeTurn] as NPCharacter
        var playerCell : (Int, Int) = dungeon.player.tilePosition
        var currentState : NPCTurnState = NPCTurnState(movementRem: enemy.speed / 5, tilePos: enemy.tilePosition, weapRange: enemy.rightHand.0.range, cellState: dungeon.getCurrentTile().getSimplifiedTileState(), fState: nil)
        currentState.tileCellStates[enemy.tilePosition.1][enemy.tilePosition.0] = 4
        
        var fringe : [NPCTurnState] = [currentState]
        var usedCelIndices : [(Int, Int)] = [(currentState.npcTilePosition.0, currentState.npcTilePosition.1)]
        var path : [Dungeon.Direction] = []
        
        //BFS to within range of player
        //Move to its own method later
        while fringe.count > 0
        {
            fringe.sort{$0.stateValue < $1.stateValue}
            currentState = fringe.removeAtIndex(0)
            
            //This may be working incorrectly
            if(Dungeon.distanceBetweenCellsByIndex(playerCell, toIndex: currentState.npcTilePosition) <= enemy.attackRange())
            {
                break
            }
            
            for s in currentState.getNextStates()
            {
                var containsS : Bool = false
                //If used indices contains the s, skip it
                for u in usedCelIndices
                {
                    if u.0 == s.npcTilePosition.0 && u.1 == s.npcTilePosition.1
                    {
                        containsS = true
                        break
                    }
                }
                
                if(!containsS)
                {
                    usedCelIndices += [s.npcTilePosition]
                    fringe += [s]
                }
            }
        }
        
        //Build path from solution, but only up to enemy speed/5
        var pathState : NPCTurnState? = currentState
        
        while pathState!.fromState != nil
        {
            path.insert(pathState!.moveDirection!, atIndex: 0)
            pathState = pathState!.fromState
        }
        
        //Move enemy
        var limitedPath : [Dungeon.Direction] = []
        
        if path.count > enemy.speed / 5
        {
            for p in 0..<(enemy.speed / 5)
            {
                limitedPath.append(path[p])
            }
        }
        else
        {
            limitedPath = path
        }
        
        if limitedPath.count > 0
        {
            dungeon.moveNPCharacterInDirections(enemy, directions: limitedPath)
        }
        
        
        /*
procedure BFS(G,v) is
2      create a queue Q - Fringe
3      create a set V - usedCellIndices
4      add v to V
5      enqueue v onto Q
6      while Q is not empty loop
7         t ← Q.dequeue()
8         if t is what we are looking for then
9            return t
10        end if
11        for all edges e in G.adjacentEdges(t) loop
12           u ← G.adjacentVertex(t,e)
13           if u is not in V then
14               add u to V
15               enqueue u onto Q
16           end if
17        end loop
18     end loop
19     return none
20 end BFS
*/
        /*
        //If not within range to attack
        if(Dungeon.distanceBetweenCellsByIndex(playerCell, toIndex: currentState.npcTilePosition) > enemy.attackRange())
        {
            
            //Find to get within range of the player
            while(Dungeon.distanceBetweenCellsByIndex(playerCell, toIndex: currentState.npcTilePosition) > enemy.attackRange() && fringe.count > 0 && currentState.movementRemaining > 0)
            {
                //Find highest valued state
                fringe.sort{$0.stateValue > $1.stateValue}
                
                var isContained : Bool = false
                
                //Don't go to the same cell twice
                while fringe.count > 0
                {
                    for u in usedCelIndices
                    {
                        if u.0 == fringe[0].npcTilePosition.0 && u.1 == fringe[0].npcTilePosition.1
                        {
                            isContained = true
                        
                            break
                        }
                    }
                    
                    if isContained
                    {
                        //Remove the used index and resort
                        fringe.removeAtIndex(0)
                        fringe.sort{$0.stateValue < $1.stateValue}
                        isContained = false
                    }
                    else
                    {
                        break
                    }
                }
                
                //If no move left, then stop searching and execute found path
                if fringe.count == 0
                {
                    break
                }
                
                currentState = fringe[0]
                usedCelIndices += [currentState.npcTilePosition]
                debugPrintln(currentState.moveDirection!.toRaw())
                
                //Add to path
                if(currentState.moveDirection != nil)
                {
                    path.append(currentState.moveDirection!)
                }
                
                //Get next states
                fringe = currentState.getNextStates()
            }
            
            //Now move
            dungeon.moveNPCharacterInDirections(enemy, directions: path)
        }
        */
        
        
        //If within range to attack, then attack
        if(Dungeon.distanceBetweenCellsByIndex(playerCell, toIndex: enemy.tilePosition) <= enemy.attackRange())
        {
            debugPrintln(enemy.name + " attacked!")
            dungeon.attackCharacter(enemy, defender: dungeon.player)
        }
        
        nextCharacterTurn()
    }
    
    func attackCharacter(gestureInfo : UILongPressGestureRecognizer)
    {
        if(gestureInfo.state == UIGestureRecognizerState.Began)
        {
            var character : Character? = dungeon.cellAtScreenLocation(mirroredPosition(gestureInfo.locationInView(self.view), xMirror: false, yMirror: true))?.characterInCell

            //If this cell has an attackable character
            if(character != nil)
            {
                dungeon.attackCharacter(dungeon.player, defender: character!)
                
                //Check for unconscious or death
                if(character!.unconscious || character!.dead)
                {
                    //Kill character
                    character?.sprite.color = UIColor.redColor()
                }
            }
            else
            {
                debugPrintln("No character in this cell")
            }
        }
    }
    
    //CHANGE THIS TO DETECT PINCH IN OUR OUT FOR OPEN OR CLOSE
    var invOpen : Bool = false
    func openInventory(gesture : UIPinchGestureRecognizer)
    {
        if(!invOpen)
        {
            dungeon.characterEquipmentViewController.open(dungeon.player)
        }
        else
        {
            dungeon.characterEquipmentViewController.close()
        }
        
        invOpen = !invOpen
    }
    
    func setGesturesEnabled(enabled : Bool)
    {
        swipeLeft.enabled = enabled
        swipeRight.enabled = enabled
        swipeUp.enabled = enabled
        swipeDown.enabled = enabled
        longTouch.enabled = enabled
        edgePanGesture.enabled = enabled
    }
    
    func mirroredPosition(position : CGPoint, xMirror : Bool, yMirror : Bool) -> CGPoint
    {
        return CGPoint(x: (xMirror ? self.view!.frame.height - position.x : position.x), y: (yMirror ? self.view!.frame.height - position.y : position.y))
    }
}

func == (lhs: (Int, Int), rhs: (Int, Int)) -> Bool
{
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}
