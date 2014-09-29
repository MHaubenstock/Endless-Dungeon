//
//  DungeonRPG.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/24/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class DungeonRPG : Dungeon
{
    var players : [Player]?
    
    func movePlayerInDirection(player : Player, direction : Direction) -> SKSpriteNode?
    {
        var proposedPosition : CGPoint!
        
        switch direction
        {
            case .North:
                proposedPosition = CGPoint(x: player.sprite.position.x, y: player.sprite.position.y + CGFloat(cellSize!))
                
            case .South:
                proposedPosition = CGPoint(x: player.sprite.position.x, y: player.sprite.position.y - CGFloat(cellSize!))
                    
            case .East:
                proposedPosition = CGPoint(x: player.sprite.position.x + CGFloat(cellSize!), y: player.sprite.position.y)
                    
            case .West:
                proposedPosition = CGPoint(x: player.sprite.position.x - CGFloat(cellSize!), y: player.sprite.position.y)
                
            case .Northeast:
                proposedPosition = CGPoint(x: player.sprite.position.x + CGFloat(cellSize!), y: player.sprite.position.y + CGFloat(cellSize!))
                
            case .Northwest:
                proposedPosition = CGPoint(x: player.sprite.position.x - CGFloat(cellSize!), y: player.sprite.position.y + CGFloat(cellSize!))
                
            case .Southeast:
                proposedPosition = CGPoint(x: player.sprite.position.x + CGFloat(cellSize!), y: player.sprite.position.y - CGFloat(cellSize!))
                
            case .Southwest:
                proposedPosition = CGPoint(x: player.sprite.position.x - CGFloat(cellSize!), y: player.sprite.position.y - CGFloat(cellSize!))
        }
        
        var cellType = cellTypeAtScreenLocation(proposedPosition)
        
        if cellType != .Wall
        {
            if cellType == .Exit
            {
                debugPrintln("Travel to next tile")
                
                //Change player position so it appears that he is coming from last tile
                player.sprite.position = getOpposingWallForLocation(proposedPosition, offGridLocation: true)
                proposedPosition = getOpposingWallForLocation(proposedPosition, offGridLocation: false)
                
                //Change proposed position so player ends on door from last tile
                player.sprite.runAction(SKAction.moveTo(proposedPosition, duration:0.25))
                
                return transitionToTileInDirection(direction).tileSprite
            }
            
            player.sprite.runAction(SKAction.moveTo(proposedPosition, duration:0.125))
        }
        
        return nil
    }
    
    func addPlayer(player : Player)
    {
        players?.append(player)
    }
    
    func addPlayerAtLocation(player : Player, location : CGPoint)
    {
        players?.append(player)
        drawPlayerAtLocation(player, location: location)
    }
    
    func drawPlayerAtLocation(player : Player, location : CGPoint)
    {
        player.sprite = SKSpriteNode()
        player.sprite.anchorPoint = CGPoint(x: -0.5, y: -0.5)
        
        player.sprite.color = UIColor.blueColor()
        player.sprite.name = player.name
        
        player.sprite.size = CGSizeMake(CGFloat(cellSize! / 2), CGFloat(cellSize! / 2))
        player.sprite.position = location
        //player.sprite.zRotation = 45.0
        player.sprite.zPosition = 1
    }
}