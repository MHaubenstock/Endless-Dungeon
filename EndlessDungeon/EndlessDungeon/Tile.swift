//
//  Tile.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/21/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class Tile
{
    var cells : [[CellType]]
    var exitPositions : [CGPoint]
    var tileSprite : SKSpriteNode = SKSpriteNode()
    var roomGenerated : Bool = false
    
    var numXCells : Int!
    var numYCells : Int!
    
    
    enum CellType
    {
        case Entrance
        case Exit
        case Wall
        case Empty
    }
    
    //Create Entrance Tile
    init(nXCells : Int, nYCells : Int)
    {
        numXCells = nXCells
        numYCells = nYCells
        
        //Fill all cells with walls
        cells = Array(count: numYCells, repeatedValue: Array(count: numXCells, repeatedValue: .Wall))
        exitPositions = Array(count: 0, repeatedValue: CGPoint())
    }
    
    func draw(gridLeft : CGFloat, gridBottom : CGFloat, cellSize : CGFloat) -> SKSpriteNode
    {
        for x in 0...(numXCells! - 1)
        {
            for y in 0...(numYCells! - 1)
            {
                tileSprite.addChild(createCell(CGPoint(x: gridLeft + cellSize * CGFloat(x), y: gridBottom + cellSize * CGFloat(y)), cellSize: cellSize, tileType: cells[y][x]))
            }
        }
        
        return tileSprite
    }
    
    func createCell(point : CGPoint, cellSize : CGFloat, tileType : CellType) -> SKSpriteNode
    {
        var sprite = SKSpriteNode()
        
        switch tileType
        {
            case .Entrance:
                sprite.color = UIColor.greenColor()
                sprite.name = "Entrance"
            
            case .Exit:
                //sprite.color = UIColor.whiteColor()
                sprite = SKSpriteNode(imageNamed: "UnexcevetedTile.png")
                sprite.name = "Exit"
            
            case .Wall:
                //sprite.color = UIColor.blackColor()
                sprite = SKSpriteNode(imageNamed: "WallTile.png")
                sprite.name = "Wall"
            
            case .Empty:
                //sprite.color = UIColor.lightGrayColor()
                sprite = SKSpriteNode(imageNamed: "UnexcevetedTile.png")
                sprite.name = "Empty"
        
            default:
                sprite.color = UIColor.blackColor()
                sprite.name = "Wall"
        }
        
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.size = CGSizeMake(cellSize, cellSize)
        sprite.position = point
        return sprite
    }
}
