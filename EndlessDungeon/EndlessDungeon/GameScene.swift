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
    
    override func didMoveToView(view: SKView)
    {
        var swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        var swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        var swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        var swipeDown : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        var longTouch : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("interactWithCell:"))
        var pinchGesture : UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("openInventory:"))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view?.addGestureRecognizer(swipeRight)
        self.view?.addGestureRecognizer(swipeLeft)
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
        self.view?.addGestureRecognizer(longTouch)
        self.view?.addGestureRecognizer(pinchGesture)
        
        //Create dungeon
        dungeon = Dungeon.sharedInstance.createDungeon(self.view?.frame, cSize: cellSize)
        
        //Add views and hide some
        //Container
        self.view?.addSubview(dungeon.containerViewController.view)
        dungeon.containerViewController.view.hidden = true
        //Inventory
        self.view?.addSubview(dungeon.characterEquipmentViewController.view)
        dungeon.characterEquipmentViewController.view.hidden = true
        
        
        //Create player
        dungeon.player = Player(playerName: "Player1")

        //Add player to dungeon
        dungeon.addPlayerAtLocation(dungeon.player, location: dungeon.entranceTile.entranceCell.position)
        //Give player a shortsword
        //dungeon.player.equipItem(Item.shortSword())
        dungeon.player.addItemToInventory(Item.shortBow())
        dungeon.player.equipItem(dungeon.player.inventory.contentsDict[.TwoHanded]![0])
        dungeon.player.addItemToInventory(Item.shortSword())
        
        
        //Testing some lighting stuff
        //player.sprite.lightingBitMask = 0x00000000
        //Attach light node to player
        //lightNode = SKLightNode()
        //lightNode.categoryBitMask = 0x00000001
        //lightNode.position = CGPoint(x: player.sprite.position.x, y: player.sprite.position.y)
        //player.sprite.addChild(lightNode)
        
        lastTileSprite = dungeon.entranceTile.tileSprite
        
        //Draw the entrance
        self.addChild(dungeon.entranceTile.tileSprite)
        self.addChild(dungeon.player.sprite)
        
        
        //CREATE A TEST ENEMY
        var goblin : NPCharacter = dungeon.createEnemyOnCurrentTile()
        self.addChild(goblin.sprite)
        self.addChild(dungeon.createEnemyOnCurrentTile().sprite)
        
        debugPrintln("Player health: " + String(dungeon.player.hitPoints) + "  Goblin health: " + String(goblin.hitPoints))
        var test : Container = dungeon.createTreasureChestOnCurrentTile(self.view!.frame)
        self.addChild(test.sprite)
        
        //dungeon.characterEquipmentViewController.open(dungeon.player)
    }
    
    /*
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        super.touchesBegan(touches, withEvent: event)

        lastTileSprite = dungeon.getCurrentTile().tileSprite
        
        for touch : AnyObject in touches
        {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            debugPrintln(dungeon.distanceBetweenCells(dungeon.cellAtScreenLocation(dungeon.player.sprite.position)!, toCell: dungeon.cellAtScreenLocation(location)!))
            
            /*
            if(dungeon.cellTypeAtScreenLocation(touchedNode.position) == Tile.CellType.Exit)
            {
                self.removeChildrenInArray([lastTileSprite])
                
                self.addChild(dungeon.transitionToTileInDirection(dungeon.wallDirectionOfEntranceOrExitAtPosition(touchedNode.position)).tileSprite)
            }
            */
        }
    }
    */
    
    override func update(currentTime: CFTimeInterval)
    {

    }
    
    func movePlayer(gestureInfo : UISwipeGestureRecognizer)
    {
        var nextTileSprite : SKSpriteNode!
        
        switch gestureInfo.direction
        {
            case UISwipeGestureRecognizerDirection.Up:
                nextTileSprite = dungeon.movePlayerInDirection(dungeon.player, direction: .North)
            
            case UISwipeGestureRecognizerDirection.Down:
                nextTileSprite = dungeon.movePlayerInDirection(dungeon.player, direction: .South)
            
            case UISwipeGestureRecognizerDirection.Right:
                nextTileSprite = dungeon.movePlayerInDirection(dungeon.player, direction: .East)
            
            case UISwipeGestureRecognizerDirection.Left:
                nextTileSprite = dungeon.movePlayerInDirection(dungeon.player, direction: .West)
            
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
                if(character!.unconscious || character!.dead)
                {
                    if(dungeon.distanceBetweenCells(dungeon.cellAtScreenLocation(dungeon.player.sprite.position)!, toCell: cell) <= 1)
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
                else
                {
                    //Don't attack yourself
                    if(!(character! is Player))
                    {
                        dungeon.attackCharacter(dungeon.player, defender: character!)
                    }
                    
                    //Check for unconscious or death
                    if(character!.unconscious || character!.dead)
                    {
                        //Kill character
                        character?.sprite.color = UIColor.redColor()
                    }
                }
            }
            else if(openable != nil)
            {
                if(dungeon.distanceBetweenCells(dungeon.cellAtScreenLocation(dungeon.player.sprite.position)!, toCell: cell) <= 1)
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
    
    func mirroredPosition(position : CGPoint, xMirror : Bool, yMirror : Bool) -> CGPoint
    {
        return CGPoint(x: (xMirror ? self.view!.frame.height - position.x : position.x), y: (yMirror ? self.view!.frame.height - position.y : position.y))
    }
}
