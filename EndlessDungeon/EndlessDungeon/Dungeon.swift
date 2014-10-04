//
//  Dungeon.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/21/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class Dungeon
{
    var tiles = [[Tile]]()  //New tiles are added to this as they are visited
    var cellSize : Int?
    var width : Int = 1
    var entranceTile : Tile!
    
    var gridLeft : CGFloat!
    var gridBottom : CGFloat!
    var currentTilePos : (Int, Int)
    
    var numXCells : Int!
    var numYCells : Int!

    enum Direction
    {
        case North
        case South
        case East
        case West
        case Northeast
        case Northwest
        case Southeast
        case Southwest
    }
    
    init(frameRect : CGRect!, cSize : Int)
    {
        cellSize = cSize
        
        //This is true because the game runs in landscape orientation
        var screenWidth = max(frameRect.width, frameRect.height)
        var screenHeight = min(frameRect.width, frameRect.height)
        
        //Calculate and Set dungeon screen bounds
        gridLeft = (screenWidth % CGFloat(cellSize!)) / 2
        gridBottom = (screenHeight % CGFloat(cellSize!)) / 2
        
        numXCells = Int(screenWidth / CGFloat(cellSize!))
        numYCells = Int(screenHeight / CGFloat(cellSize!))
        
        entranceTile = Tile(nXCells: numXCells, nYCells: numYCells, gridLeft: gridLeft, gridBottom: gridBottom, cellSize: cellSize!)
        
        //Populate entrance tile
        tiles.append(Array(count: 1, repeatedValue: entranceTile))
        
        currentTilePos = (0, 0)
        
        generateEntrance()
        
        tiles[currentTilePos.1][currentTilePos.0] = entranceTile
    }
    
    func drawTile(x : Int, y : Int) -> SKSpriteNode
    {
        if !tiles[y][x].roomGenerated
        {
            tiles[y][x] = generateRoomForTile(x, tileY: y)
        }
        
        return tiles[y][x].draw(gridLeft, gridBottom: gridBottom, cellSize: CGFloat(cellSize!))
    }
    
    func transitionToTileInDirection(direction : Direction) -> Tile
    {
        var nextTile : Tile!
        
        //Add a new tile if one does not exist for the tile you are entering
        switch direction
        {
            case .North:
                //If you need a new tile in the north direction
                if currentTilePos.1 == 0
                {
                    //Extend array
                    tiles.insert(Array(count: width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells, gridLeft: gridLeft, gridBottom: gridBottom, cellSize: cellSize!)), atIndex: 0)
                    nextTile = generateRoomForTile(currentTilePos.0, tileY: 0)
                    tiles[currentTilePos.1][currentTilePos.0] = nextTile
                }
                else
                {
                    nextTile = tiles[currentTilePos.1 - 1][currentTilePos.0]
                    //THIS LINE MIGHT BE BROKEN, ALSO IN OTHER CASES
                    currentTilePos.1 -= 1
                }
                
            case .South:
                //If you need a new tile in the south direction
                if currentTilePos.1 == tiles.count - 1
                {
                    //Extend array
                    tiles.append(Array(count: width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells, gridLeft: gridLeft, gridBottom: gridBottom, cellSize: cellSize!)))
                    nextTile = generateRoomForTile(currentTilePos.0, tileY: currentTilePos.1 + 1)
                    tiles[currentTilePos.1 + 1][currentTilePos.0] = nextTile
                }
                else
                {
                    nextTile = tiles[currentTilePos.1 + 1][currentTilePos.0]
                }
            
                currentTilePos.1 += 1
            
            case .East:
                //If you need a new tile in the east direction
                if currentTilePos.0 == tiles[currentTilePos.1].count - 1
                {
                    //Extend array
                    setDungeonWidth(width + 1, appendToFront: false)
                    nextTile = generateRoomForTile(currentTilePos.0 + 1, tileY: currentTilePos.1)
                    tiles[currentTilePos.1][currentTilePos.0 + 1] = nextTile
                }
                else
                {
                    nextTile = tiles[currentTilePos.1][currentTilePos.0 + 1]
                }
                
                currentTilePos.0 += 1
            
            case .West:
                //If you need a new tile in the west direction
                if currentTilePos.0 == 0
                {
                    //Extend array
                    setDungeonWidth(width + 1, appendToFront: true)
                    nextTile = generateRoomForTile(0, tileY: currentTilePos.1)
                    tiles[currentTilePos.1][currentTilePos.0] = nextTile
                }
                else
                {
                    nextTile = tiles[currentTilePos.1][currentTilePos.0 - 1]
                    currentTilePos.0 -= 1
                }
            
            default:
                return Tile(nXCells: numXCells, nYCells: numYCells, gridLeft: gridLeft, gridBottom: gridBottom, cellSize: cellSize!)
        }
        
        nextTile.tileSprite = drawTile(currentTilePos.0, y: currentTilePos.1)
        
        return nextTile
    }
    
    func generateEntrance()
    {
        //Roll for entrance
        //Save this so you dont create an exit on the same wall as the entrance
        var entranceDirection : Direction = getDirectionWithWeights(5, southWeight: 5, eastWeight: 5, westWeight: 5)
        var entranceLocation : (Int, Int) = rollDoorLocationForDirection(entranceDirection)
        
        //Make dungeon entrance
        entranceTile.entranceCell = entranceTile.cells[entranceLocation.1][entranceLocation.0]
        entranceTile.entranceCell.cellType = .Entrance
        
        //Roll for exits
        var numOfExits : Int = Int(arc4random_uniform(3)) + 1    //1 to 3 exits
        
        for c in 0...(numOfExits - 1)
        {
            //entranceTile.exitPositions.append(rollDoorLocationForDirection(getDirectionWithWeights((entranceDirection == .North ? 0 : 1), southWeight: (entranceDirection == .South ? 0 : 1), eastWeight: (entranceDirection == .East ? 0 : 1), westWeight: (entranceDirection == .West ? 0 : 1))))
            
            var doorLocation = rollDoorLocationForDirection(getDirectionWithWeights((entranceDirection == .North ? 0 : 1), southWeight: (entranceDirection == .South ? 0 : 1), eastWeight: (entranceDirection == .East ? 0 : 1), westWeight: (entranceDirection == .West ? 0 : 1)))
            
            entranceTile.exitCells.append(entranceTile.cells[doorLocation.1][doorLocation.0])
            
            //Make exit
            //entranceTile.cells[Int(entranceTile.exitPositions.last!.y)][Int(entranceTile.exitPositions.last!.x)] = .Exit
            entranceTile.cells[doorLocation.1][doorLocation.0].cellType = .Exit
        }
        
        //Walk from entrance to each exit
        var currentPosition : (Int, Int) = entranceLocation
        var noise : CGFloat = 50 //The higher the noise the more empty a tile should be
        
        for exitCell in entranceTile.exitCells
        {
            var exit : (Int, Int) = exitCell.index
            
            while currentPosition.0 != exit.0 || currentPosition.1 != exit.1
            {
                var nextPosition : (Int, Int) = Dungeon.getNeighborCellindex(currentPosition, exitDirection: getDirectionWithWeights(CGFloat(exit.1 - currentPosition.1) + noise, southWeight: CGFloat(currentPosition.1 - exit.1) + noise, eastWeight: CGFloat(exit.0 - currentPosition.0) + noise, westWeight: CGFloat(currentPosition.0 - exit.0) + noise))
                
                if isValidCell(nextPosition)
                {
                    entranceTile.cells[nextPosition.1][nextPosition.0].cellType = .Empty
                    currentPosition = nextPosition
                }
                else if nextPosition.0 == exit.0 && nextPosition.1 == exit.1
                {
                    currentPosition = nextPosition
                }
            }
        }
        
        processTileCells(entranceTile)
        
        entranceTile.roomGenerated = true
        entranceTile.tileSprite = drawTile(currentTilePos.0, y: currentTilePos.1)
    }

    func generateRoomForTile(tileX : Int, tileY : Int) -> Tile
    {
        var nextTile : Tile = Tile(nXCells: numXCells, nYCells: numYCells, gridLeft: gridLeft, gridBottom: gridBottom, cellSize: cellSize!)
        var hasNorthExits : Bool = false
        var hasSouthExits : Bool = false
        var hasEastExits : Bool = false
        var hasWestExits : Bool = false
        var exitPositions : [(Int, Int)] = [(Int, Int)]()
        
        //Add exits from other surrounding already generated tiles
        //Only already generated tiles will have exits
        if tileY > 0
        {
            exitPositions += getExitsOnWallForTile(tiles[tileY - 1][tileX], direction: .South)
            //nextTile.exitCells += getExitsCellsOnWallForTile(tiles[tileY - 1][tileX], direction: .South)
            hasNorthExits = true
        }
        
        if tileY < tiles.count - 1
        {
            exitPositions += getExitsOnWallForTile(tiles[tileY + 1][tileX], direction: .North)
            //nextTile.exitCells += getExitsCellsOnWallForTile(tiles[tileY + 1][tileX], direction: .North)
            hasSouthExits = true
        }
        
        if tileX > 0
        {
            exitPositions += getExitsOnWallForTile(tiles[tileY][tileX - 1], direction: .East)
            //nextTile.exitCells += getExitsCellsOnWallForTile(tiles[tileY][tileX - 1], direction: .East)
            hasWestExits = true
        }
        
        if tileX < width - 1
        {
            exitPositions += getExitsOnWallForTile(tiles[tileY][tileX + 1], direction: .West)
            //nextTile.exitCells += getExitsCellsOnWallForTile(tiles[tileY][tileX + 1], direction: .West)
            hasEastExits = true
        }
        //

        for pos in exitPositions
        {
            nextTile.exitCells.append(nextTile.cells[pos.1][pos.0])
            nextTile.cells[pos.1][pos.0].cellType = .Exit
        }
        
        /*
        for cell in nextTile.exitCells
        {
            cell.cellType = .Exit
        }
        */
        
        //Roll for exits
        var numOfExits : Int = Int(arc4random_uniform(3)) + 1    //1 to 3 exits
        
        for c in 0...(numOfExits - 1)
        {
            var doorLocation = rollDoorLocationForDirection(getDirectionWithWeights((hasNorthExits ? 0 : 1), southWeight: (hasSouthExits ? 0 : 1), eastWeight: (hasEastExits ? 0 : 1), westWeight: (hasWestExits ? 0 : 1)))
            
            nextTile.exitCells.append(nextTile.cells[doorLocation.1][doorLocation.0])
            
            //Make exit
            nextTile.cells[doorLocation.1][doorLocation.0].cellType = .Exit
        }
        
        //Walk from an exit to each other exit
        //Use first exit now, should be exit from last tile
        //Change to use exact exit from last tile later
        var currentPosition : (Int, Int) = nextTile.exitCells[0].index
        var noise : CGFloat = 50 //The higher the noise the more empty a tile should be
        
        for exitCell in nextTile.exitCells
        {
            var exit : (Int, Int) = exitCell.index
            
            while currentPosition.0 != exit.0 || currentPosition.1 != exit.1
            {
                var nextPosition : (Int, Int) = Dungeon.getNeighborCellindex(currentPosition, exitDirection: getDirectionWithWeights(CGFloat(exit.1 - currentPosition.1) + noise, southWeight: CGFloat(currentPosition.1 - exit.1) + noise, eastWeight: CGFloat(exit.0 - currentPosition.0) + noise, westWeight: CGFloat(currentPosition.0 - exit.0) + noise))
                
                if isValidCell(nextPosition)
                {
                    nextTile.cells[nextPosition.1][nextPosition.0].cellType = .Empty
                    currentPosition = nextPosition
                }
                else if nextPosition.0 == exit.0 && nextPosition.1 == exit.1
                {
                    currentPosition = nextPosition
                }
            }
        }
        
        processTileCells(nextTile)
        
        nextTile.roomGenerated = true
        
        return nextTile
    }
    
    func processTileCells(tile : Tile)
    {
        //This function looks at each cell and decides which image to use
        for cellRow in tile.cells
        {
            for cell in cellRow
            {
                //Dictionary of neighbor cells
                var nCells : Dictionary<Direction, Cell> = tile.getNeighboringCells(cell, getDiagonals: false)

                var nType : Cell.CellType? = nCells[.North]?.cellType
                var sType : Cell.CellType? = nCells[.South]?.cellType
                var eType : Cell.CellType? = nCells[.East]?.cellType
                var wType : Cell.CellType? = nCells[.West]?.cellType
                
                var n : Bool = nType == .Wall
                var s : Bool = sType == .Wall
                var e : Bool = eType == .Wall
                var w : Bool = wType == .Wall
                
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
            }
        }
    }
    
    func setDungeonWidth(dungeonWidth : Int, appendToFront : Bool)
    {
        //Cannot make the dungeon smaller
        if dungeonWidth < width
        {
            debugPrintln("Cannot make the dungeon smaller")
            return
        }
        
        for var index = 0; index < tiles.count; ++index
        {
            if appendToFront
            {
                tiles[index] = Array(count: dungeonWidth - width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells, gridLeft: gridLeft, gridBottom: gridBottom, cellSize: cellSize!)) + tiles[index]
            }
            else
            {
                tiles[index] = tiles[index] + Array(count: dungeonWidth - width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells, gridLeft: gridLeft, gridBottom: gridBottom, cellSize: cellSize!))
            }
        }
        
        width = dungeonWidth
    }
    
    func getExitsOnWallForTile(tile : Tile, direction : Direction) -> [(Int, Int)]
    {
        var exits : [(Int, Int)] = [(Int, Int)]()
        
        for exitCell in tile.exitCells
        {
            var exit : (Int, Int) = exitCell.index
            
            switch direction
            {
                case .North:
                    if exit.1 == numYCells - 1
                    {
                        //exits.append((exit.0, 0))
                        exits += [(exit.0, 0)]
                    }
                    
                case .South:
                    if exit.1 == 0
                    {
                        //exits.append(CGPoint(x: exit.x, y: CGFloat(numYCells - 1)))
                        exits += [(exit.0, numYCells - 1)]
                    }
                    
                case .East:
                    if exit.0 == numXCells - 1
                    {
                        //exits.append(CGPoint(x: 0, y: exit.y))
                        exits += [(0, exit.1)]
                    }
                    
                case .West:
                    if exit.0 == 0
                    {
                        //exits.append(CGPoint(x: CGFloat(numXCells - 1), y: exit.y))
                        exits += [(numXCells - 1, exit.1)]
                    }
                
                default:
                    debugPrintln("There will never be a diagonal exit")
            }
        }
        
        return exits
    }
    
    func getExitsCellsOnWallForTile(tile : Tile, direction : Direction) -> [Cell]
    {
        var cells : [Cell] = [Cell]()
        
        for exitCell in tile.exitCells
        {
            switch direction
            {
                case .North:
                    if exitCell.index.1 == numYCells - 1
                    {
                        //exits.append((exit.0, 0))
                        //exits += [(exit.0, 0)]
                        cells.append(tile.cells[0][exitCell.index.0])
                    }
                    
                case .South:
                    if exitCell.index.1 == 0
                    {
                        //exits.append(CGPoint(x: exit.x, y: CGFloat(numYCells - 1)))
                        //exits += [(exit.0, numYCells - 1)]
                        cells.append(tile.cells[numYCells - 1][exitCell.index.0])
                    }
                    
                case .East:
                    if exitCell.index.0 == numXCells - 1
                    {
                        //exits.append(CGPoint(x: 0, y: exit.y))
                        //exits += [(0, exit.1)]
                        cells.append(tile.cells[exitCell.index.1][0])
                    }
                    
                case .West:
                    if exitCell.index.0 == 0
                    {
                        //exits.append(CGPoint(x: CGFloat(numXCells - 1), y: exit.y))
                        //exits += [(numXCells - 1, exit.1)]
                        cells.append(tile.cells[exitCell.index.1][numXCells - 1])
                    }
                    
                default:
                    debugPrintln("There will never be a diagonal exit")
            }
        }
        
        return cells
    }
    
    func rollDoorLocationForDirection(dir : Direction) -> (Int, Int)
    {
        var roll : Int!
        
        if dir == .North || dir == .South
        {
            roll = Int(arc4random_uniform(UInt32(numXCells - 2))) + 1
            
            if dir == .South
            {
                return (roll, 0)
            }
            else
            {
                return (roll, numYCells - 1)
            }
        }
        else
        {
            roll = Int(arc4random_uniform(UInt32(numYCells - 2))) + 1
            
            if dir == .West
            {
                return (0, roll)
            }
            else
            {
                return (numXCells - 1, roll)
            }
        }
    }
    
    func getDirectionWithWeights(northWeight : CGFloat, southWeight : CGFloat, eastWeight : CGFloat, westWeight : CGFloat) -> Direction
    {
        var totalWeight : CGFloat = northWeight + southWeight + eastWeight + westWeight
        var newNorthWeight = northWeight * CGFloat(100 / totalWeight)
        var newSouthWeight = southWeight * CGFloat(100 / totalWeight)
        var newEastWeight = eastWeight * CGFloat(100 / totalWeight)
        var newWestWeight = westWeight * CGFloat(100 / totalWeight)
        var roll : CGFloat = CGFloat(arc4random_uniform(100) + 1)
        
        if roll <= newNorthWeight
        {
            return .North
        }
        else if roll > newNorthWeight && roll <= newSouthWeight + newNorthWeight
        {
            return .South
        }
        else if roll > newSouthWeight + newNorthWeight && roll <= newEastWeight + newSouthWeight + newNorthWeight
        {
            return .East
        }
        else
        {
            return .West
        }
    }
    
    //Gets opposing wall for an exit. if offGridLocation is true it gets one cell past the opposing wall to use for player transitioning effect
    func getOpposingWallForLocation(location : CGPoint, offGridLocation : Bool) -> CGPoint
    {
        var locationIndex = cellIndexAtScreenLocation(location)
        
        //if on west wall
        if Int(locationIndex.x) == numXCells - 1
        {
            //return east wall
            return CGPoint(x: CGFloat(gridLeft + CGFloat(cellSize!) * CGFloat(numXCells - (offGridLocation ? 0 : 1))), y: CGFloat(location.y))
        }
        //if east wall
        else if locationIndex.x == 0
        {
            //return west wall
            return CGPoint(x: CGFloat(gridLeft - CGFloat(cellSize!) * (offGridLocation ? 1 : 0)), y: CGFloat(location.y))
        }
        //if north wall
        else if locationIndex.y == 0
        {
            //return south wall
            return CGPoint(x: CGFloat(location.x), y: CGFloat(gridBottom - CGFloat(cellSize!) * (offGridLocation ? 1 : 0)))
        }
        //if south wall
        else
        {
            //return north wall
            return CGPoint(x: CGFloat(location.x), y: CGFloat(gridBottom + CGFloat(cellSize!) * CGFloat(numYCells - (offGridLocation ? 0 : 1))))
        }
    }
    
    class func getNeighborCellindex(index : (Int, Int), exitDirection : Direction) -> (Int, Int)
    {
        switch exitDirection
        {
            case .North:
                return (index.0, index.1 + 1)
                
            case .South:
                return (index.0, index.1 - 1)
                
            case .East:
                return (index.0 + 1, index.1)
                
            case .West:
                return (index.0 - 1, index.1)
                
            default:
                return (index.0, index.1)
        }
    }
    
    func getCurrentTile() -> Tile
    {
        //return tiles[Int(currentTilePos.y)][Int(currentTilePos.x)]
        return tiles[currentTilePos.1][currentTilePos.0]
    }
    
    func screenLocationForIndex(index : CGPoint) -> CGPoint
    {
        return CGPoint(x: (index.x * CGFloat(cellSize!)) + gridLeft, y: (index.y * CGFloat(cellSize!)) + gridBottom)
    }
    
    func cellIndexAtScreenLocation(location : CGPoint) -> CGPoint
    {
        return CGPoint(x: numXCells - 1 - Int(location.x - gridLeft) / cellSize!, y: numYCells - 1 - Int(location.y - gridBottom) / cellSize!)
    }
    
    func cellAtScreenLocation(location : CGPoint) -> Cell?
    {
        var currentTile : Tile = getCurrentTile()
        
        var xIndex = Int(location.x - gridLeft) / cellSize!
        var yIndex = Int(location.y - gridBottom) / cellSize!
        
        //If it's not a valid cell position then call it a wall
        if xIndex < 0 || xIndex > numXCells - 1 || yIndex < 0 || yIndex > numYCells - 1
        {
            return nil
        }
        
        return currentTile.cells[yIndex][xIndex]
    }
    
    func cellTypeAtScreenLocation(location : CGPoint) -> Cell.CellType
    {
        var currentTile : Tile = getCurrentTile()

        var xIndex = Int(location.x - gridLeft) / cellSize!
        var yIndex = Int(location.y - gridBottom) / cellSize!

        //If it's not a valid cell position then call it a wall
        if xIndex < 0 || xIndex > numXCells - 1 || yIndex < 0 || yIndex > numYCells - 1
        {
            return .Wall
        }
        
        return currentTile.cells[yIndex][xIndex].cellType
    }
    
    func wallDirectionOfEntranceOrExitAtPosition(position : CGPoint) -> Direction
    {
        var currentTile : Tile = getCurrentTile()
        
        var xIndex = Int(position.x - gridLeft) / cellSize!
        var yIndex = Int(position.y - gridBottom) / cellSize!
        
        if xIndex == 0
        {
            return .West
        }
        else if xIndex == numXCells - 1
        {
            return .East
        }
        else if yIndex == 0
        {
            return .South
        }
        else
        {
            return .North
        }
    }
    
    func isValidCell(cell : (Int, Int)) -> Bool
    {
        return (cell.0 >= 1 && cell.0 < numXCells - 1) && (cell.1 >= 1 && cell.1 < numYCells - 1)
    }
}