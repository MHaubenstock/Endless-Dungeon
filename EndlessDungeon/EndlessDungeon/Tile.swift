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
    var enemies : [NPCharacter] = []
    var lootables : [Container] = []
    
    var cells : [[Cell]]
    var entranceCell : Cell
    var exitCells : [Cell]
    var containers : [Container] = []
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
    
    func draw() -> SKSpriteNode
    {
        for x in 0...(numXCells! - 1)
        {
            for y in 0...(numYCells! - 1)
            {
                //tileSprite.addChild(cells[y][x].sprite!)
                tileSprite.addChild(createCell(cells[y][x], cellSize: CGFloat(Dungeon.sharedInstance.cellSize)))
            }
        }
        
        return tileSprite
    }
    
    /*
    func draw(gridLeft : CGFloat, gridBottom : CGFloat, cellSize : CGFloat) -> SKSpriteNode
    {
        for x in 0...(numXCells! - 1)
        {
            for y in 0...(numYCells! - 1)
            {
                //tileSprite.addChild(createCell(cells[y][x], cellSize: cellSize))
                tileSprite.addChild(createCell(cells[y][x], cellSize: cellSize))
            }
        }
        
        return tileSprite
    }
    */
    
    func processCells()
    {
        var cellSize : CGFloat = CGFloat(Dungeon.sharedInstance.cellSize)
        var wallBorderWidth : CGFloat = cellSize * 0.2
        
        //This function looks at each cell and decides which image to use
        for cellRow in cells
        {
            //TODO: Update this function to draw the tiles instead of loading images, also get the diagonals and check for walls so the dungeon can correctly draw corners
            for cell in cellRow
            {
                var cellSprite : SKShapeNode = SKShapeNode(rectOfSize: CGSizeMake(cellSize, cellSize))
                
                var cellWallPath = CGPathCreateMutable()
                CGPathAddRect(cellWallPath, nil, CGRectMake(0, 0, cellSize, cellSize))
                
                //If it's an empty floor tile
                if(cell.cellType == .Empty || cell.cellType == .Exit || cell.cellType == .Entrance)
                {
                    //No need to draw anything, it's just an empty rect which is created upon instantiation
                }
                //Else if it is a wall tile
                else
                {
                    //Dictionary of neighbor cells
                    var nCells : Dictionary<Dungeon.Direction, Cell> = getNeighboringCells(cell, getDiagonals: true)
                    
                    var nType : Cell.CellType? = nCells[.North]?.cellType
                    var sType : Cell.CellType? = nCells[.South]?.cellType
                    var eType : Cell.CellType? = nCells[.East]?.cellType
                    var wType : Cell.CellType? = nCells[.West]?.cellType
                    var neType : Cell.CellType? = nCells[.Northeast]?.cellType
                    var nwType : Cell.CellType? = nCells[.Northwest]?.cellType
                    var seType : Cell.CellType? = nCells[.Southeast]?.cellType
                    var swType : Cell.CellType? = nCells[.Southwest]?.cellType
                    
                    var n : Bool = nType == .Wall
                    var s : Bool = sType == .Wall
                    var e : Bool = eType == .Wall
                    var w : Bool = wType == .Wall
                    var ne : Bool = neType == .Wall
                    var nw : Bool = nwType == .Wall
                    var se : Bool = seType == .Wall
                    var sw : Bool = swType == .Wall
                    
                    //Draw north wall
                    if(n)
                    {
                        //CGPathMoveToPoint(cellWallPath, nil, 0, wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, cellSize, wallBorderWidth)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(0, 0, cellSize, wallBorderWidth))
                    }
                    
                    //Draw east wall
                    if(e)
                    {
                        //CGPathMoveToPoint(cellWallPath, nil, cellSize - wallBorderWidth, 0)
                        //CGPathAddLineToPoint(cellWallPath, nil, cellSize - wallBorderWidth, cellSize)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(cellSize - wallBorderWidth, 0, wallBorderWidth, cellSize))
                    }
                    
                    //Draw south wall
                    if(s)
                    {
                        //CGPathMoveToPoint(cellWallPath, nil, 0, cellSize - wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, cellSize, cellSize - wallBorderWidth)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(0, cellSize - wallBorderWidth, cellSize, cellSize - wallBorderWidth))
                    }
                    
                    //Draw west wall
                    if(w)
                    {
                        //CGPathMoveToPoint(cellWallPath, nil, wallBorderWidth, 0)
                        //CGPathAddLineToPoint(cellWallPath, nil, wallBorderWidth, cellSize)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(0, 0, wallBorderWidth, cellSize))
                    }
                    
                    //Draw square in northeast corner
                    if(ne)
                    {
                        ///CGPathMoveToPoint(cellWallPath, nil, cellSize - wallBorderWidth, 0)
                        //CGPathAddLineToPoint(cellWallPath, nil, cellSize - wallBorderWidth, wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, cellSize, wallBorderWidth)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(cellSize - wallBorderWidth, 0, wallBorderWidth, wallBorderWidth))
                    }
                    
                    //Draw square in northeast corner
                    if(nw)
                    {
                        //CGPathMoveToPoint(cellWallPath, nil, wallBorderWidth, 0)
                        //CGPathAddLineToPoint(cellWallPath, nil, wallBorderWidth, wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, 0, wallBorderWidth)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(0, 0, wallBorderWidth, wallBorderWidth))
                    }
                    
                    //Draw square in northeast corner
                    if(se)
                    {
                        //CGPathMoveToPoint(cellWallPath, nil, cellSize, cellSize - wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, cellSize - wallBorderWidth, cellSize - wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, cellSize - wallBorderWidth, cellSize)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(cellSize - wallBorderWidth, cellSize - wallBorderWidth, wallBorderWidth, wallBorderWidth))
                    }
                    
                    //Draw square in northeast corner
                    if(sw)
                    {
                        //CGPathMoveToPoint(cellWallPath, nil, 0, cellSize - wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, wallBorderWidth, cellSize - wallBorderWidth)
                        //CGPathAddLineToPoint(cellWallPath, nil, wallBorderWidth, cellSize)
                        CGPathAddRect(cellWallPath, nil, CGRectMake(0, cellSize - wallBorderWidth, wallBorderWidth, wallBorderWidth))
                    }
                }

                cellSprite.strokeColor = UIColor.blueColor()
                cellSprite.fillColor = UIColor.grayColor()
                cellSprite.path = cellWallPath
                cell.sprite = cellSprite
                
                /*
                if(cell.cellType == .Empty || cell.cellType == .Exit || cell.cellType == .Entrance)
                {
                    cell.cellImage = "FloorTile.png"
                }
                else if(!n && !s && !e && !w)
                {
                    cell.cellImage = "Column.png"
                }
                else if(!n && !s && !e && w)
                {
                    cell.cellImage = "RightSingleTile.png"
                }
                else if(!n && !s && e && !w)
                {
                    cell.cellImage = "LeftSingleTile.png"
                }
                else if(!n && !s && e && w)
                {
                    cell.cellImage = "HorizontalSingleTile.png"
                }
                else if(!n && s && !e && !w)
                {
                    cell.cellImage = "BackSingleTile.png"
                }
                else if(!n && s && !e && w)
                {
                    cell.cellImage = "BackRightCorner.png"
                }
                else if(!n && s && e && !w)
                {
                    cell.cellImage = "BackLeftCorner.png"
                }
                else if(!n && s && e && w)
                {
                    cell.cellImage = "BackWall.png"
                }
                else if(n && !s && !e && !w)
                {
                    cell.cellImage = "FrontSingleTile.png"
                }
                else if(n && !s && !e && w)
                {
                    cell.cellImage = "FrontRightCorner.png"
                }
                else if(n && !s && e && !w)
                {
                    cell.cellImage = "FrontLeftCorner.png"
                }
                else if(n && !s && e && w)
                {
                    cell.cellImage = "FrontWall.png"
                }
                else if(n && s && !e && !w)
                {
                    cell.cellImage = "VerticalSingleTile.png"
                }
                else if(n && s && !e && w)
                {
                    cell.cellImage = "RightWall.png"
                }
                else if(n && s && e && !w)
                {
                    cell.cellImage = "LeftWall.png"
                }
                else if(n && s && e && w)
                {
                    cell.cellImage = "UnexcavatedTile.png"
                }
                */
            }
        }
    }
    

    func createCell(cell : Cell, cellSize : CGFloat) -> SKShapeNode
    {
        //var sprite = SKSpriteNode(imageNamed: cell.cellImage)
        cell.sprite!.name = cell.cellImage.stringByReplacingOccurrencesOfString(".png", withString: "", options: nil, range: nil)
        
        if(cell.sprite!.name == "Column")
        {
            //cell.sprite!.shadowCastBitMask = 1
            //cell.sprite!.lightingBitMask = 1
        }
        
        //cell.sprite!.anchorPoint = CGPoint(x: 0, y: 0)
        //cell.sprite!.size = CGSizeMake(cellSize, cellSize)
        cell.sprite!.position = cell.position
        
        return cell.sprite!
    }
    
    func getCellsOfType(type : Cell.CellType) -> [Cell]
    {
        var theCells : [Cell] = [Cell]()
        
        for x in 0...(numXCells! - 1)
        {
            for y in 0...(numYCells! - 1)
            {
                if(cells[y][x].cellType == type)
                {
                    theCells.append(cells[y][x])
                }
            }
        }
        
        return theCells
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
    
    //For state searches and such
    func getSimplifiedTileState() -> [[Int]]
    {
        var simplifiedTileState : [[Int]] = Array(count: numYCells, repeatedValue: Array(count: numXCells, repeatedValue: 0))
        
        for x in 0...(numXCells! - 1)
        {
            for y in 0...(numYCells! - 1)
            {
                if(cells[y][x].cellType == .Wall)
                {
                    simplifiedTileState[y][x] = 0
                }
                else if(cells[y][x].characterInCell != nil)
                {
                    if(cells[y][x].characterInCell is Player)
                    {
                        simplifiedTileState[y][x] = 1
                    }
                    else if(cells[y][x].characterInCell is NPCharacter)
                    {
                        simplifiedTileState[y][x] = 2
                    }
                }
                else
                {
                    simplifiedTileState[y][x] = 3
                }
            }
        }
        
        return simplifiedTileState
    }
}
