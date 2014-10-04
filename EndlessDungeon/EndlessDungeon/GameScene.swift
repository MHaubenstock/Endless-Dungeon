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
    var dungeon : DungeonRPG!
    var player : Player!
    var lastTileSprite : SKSpriteNode!
    
    override func didMoveToView(view: SKView)
    {
        var swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        var swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        var swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        var swipeDown : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("movePlayer:"))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view?.addGestureRecognizer(swipeRight)
        self.view?.addGestureRecognizer(swipeLeft)
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
        
        //Create dungeon
        dungeon = DungeonRPG(frameRect: self.view?.frame, cSize: cellSize)
        
        //Create player
        player = Player(playerName: "Player1")

        //Add player to dungeon
        dungeon.addPlayerAtLocation(player, location: dungeon.entranceTile.entranceCell.position)
        
        lastTileSprite = dungeon.entranceTile.tileSprite
        
        //Draw the entrance
        self.addChild(dungeon.entranceTile.tileSprite)
        self.addChild(player.sprite)
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

            debugPrintln(dungeon.cellAtScreenLocation(touchedNode.position)?.cellImage)
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
                nextTileSprite = dungeon.movePlayerInDirection(player, direction: .North)
            
            case UISwipeGestureRecognizerDirection.Down:
                nextTileSprite = dungeon.movePlayerInDirection(player, direction: .South)
            
            case UISwipeGestureRecognizerDirection.Right:
                nextTileSprite = dungeon.movePlayerInDirection(player, direction: .East)
            
            case UISwipeGestureRecognizerDirection.Left:
                nextTileSprite = dungeon.movePlayerInDirection(player, direction: .West)
            
            default:
                debugPrintln("Not sure which direction you swiped... are you a wizard?")
        }
        
        //Moves to new tile
        if nextTileSprite != nil
        {
            self.removeChildrenInArray([lastTileSprite])
            self.addChild(nextTileSprite)
            lastTileSprite = nextTileSprite
        }
    }
}
