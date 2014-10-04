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
    var cells : [[Cell]]
    var entranceCell : Cell
    var exitCells : [Cell]
    var tileSprite : SKSpriteNode = SKSpriteNode()
    var roomGenerated : Bool = false
    
    var numXCells : Int!
    var numYCells : Int!
    
    //Create Entrance Tile
    init(nXCells : Int, nYCells : Int)
    {
        numXCells = nXCells
        numYCells = nYCells
        
        //Fill all cells with walls
        cells = Array(count: numYCells, repeatedValue: Array(count: numXCells, repeatedValue: Cell()))
        exitCells = Array(count: 0, repeatedValue: Cell(type: .Exit))
        entranceCell = Cell()
    }
    
    init(nXCells : Int, nYCells : Int, gridLeft : CGFloat, gridBottom : CGFloat, cellSize : Int)
    {
        numXCells = nXCells
        numYCells = nYCells
        
        //Fill all cells with walls
        cells = Array(count: numYCells, repeatedValue: Array(count: numXCells, repeatedValue: Cell()))
        exitCells = Array(count: 0, repeatedValue: Cell(type: .Exit))
        
        //Initialize each cell's position and index
        for x in 0...(numXCells! - 1)
        {
            for y in 0...(numYCells! - 1)
            {
                cells[y][x] = Cell(theIndex: (x, y), type: .Wall, thePosition: CGPoint(x: gridLeft + CGFloat(cellSize * x), y: gridBottom + CGFloat(cellSize * y)))
            }
        }
        
        entranceCell = Cell()
    }
    
    func draw(gridLeft : CGFloat, gridBottom : CGFloat, cellSize : CGFloat) -> SKSpriteNode
    {
        for x in 0...(numXCells! - 1)
        {
            for y in 0...(numYCells! - 1)
            {
                tileSprite.addChild(createCell(cells[y][x], cellSize: cellSize))
            }
        }
        
        return tileSprite
    }
    
    func createCell(cell : Cell, cellSize : CGFloat) -> SKSpriteNode
    {
        var sprite = SKSpriteNode(imageNamed: cell.cellImage)
        sprite.name = cell.cellImage.stringByReplacingOccurrencesOfString(".png", withString: "", options: nil, range: nil)
        
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.size = CGSizeMake(cellSize, cellSize)
        sprite.position = cell.position
        return sprite
    }
    
    func getNeighboringCells(cell : Cell, getDiagonals : Bool) -> Dictionary<Dungeon.Direction, Cell>
    {
        var neighborDictionary : Dictionary<Dungeon.Direction, Cell> = Dictionary<Dungeon.Direction, Cell>()
        
        //North
        var neighborCellIndex : (Int, Int) = Dungeon.getNeighborCellindex(cell.index, exitDirection: .North)
        
        if(isValidIndex(neighborCellIndex))
        {
            neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .North)
        }
        
        //South
        neighborCellIndex = Dungeon.getNeighborCellindex(cell.index, exitDirection: .South)
        
        if(isValidIndex(neighborCellIndex))
        {
            neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .South)
        }
        
        //East
        neighborCellIndex = Dungeon.getNeighborCellindex(cell.index, exitDirection: .East)
        
        if(isValidIndex(neighborCellIndex))
        {
            neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .East)
        }
        
        //West
        neighborCellIndex = Dungeon.getNeighborCellindex(cell.index, exitDirection: .West)
        
        if(isValidIndex(neighborCellIndex))
        {
            neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .West)
        }
        
        if getDiagonals
        {
            //Northeast
            neighborCellIndex = Dungeon.getNeighborCellindex(cell.index, exitDirection: .Northeast)
            
            if(isValidIndex(neighborCellIndex))
            {
                neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .Northeast)
            }
            
            //Northwest
            neighborCellIndex = Dungeon.getNeighborCellindex(cell.index, exitDirection: .Northwest)
            
            if(isValidIndex(neighborCellIndex))
            {
                neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .Northwest)
            }
            
            //Southeast
            neighborCellIndex = Dungeon.getNeighborCellindex(cell.index, exitDirection: .Southeast)
            
            if(isValidIndex(neighborCellIndex))
            {
                neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .Southeast)
            }
            
            //Southwest
            neighborCellIndex = Dungeon.getNeighborCellindex(cell.index, exitDirection: .Southwest)
            
            if(isValidIndex(neighborCellIndex))
            {
                neighborDictionary.updateValue(cells[neighborCellIndex.1][neighborCellIndex.0], forKey: .Southwest)
            }
        }
        
        return neighborDictionary
    }
    
    func isValidIndex(theIndex : (Int, Int)) -> Bool
    {
        return (theIndex.0 >= 0 && theIndex.0 < numXCells && theIndex.1 >= 0 && theIndex.1 < numYCells)
    }
}
