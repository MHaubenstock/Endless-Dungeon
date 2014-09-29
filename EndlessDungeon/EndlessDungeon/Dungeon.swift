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
    var entranceCell : CGPoint!
    
    var gridLeft : CGFloat!
    var gridBottom : CGFloat!
    var currentTilePos : CGPoint!
    
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
        
        entranceTile = Tile(nXCells: numXCells, nYCells: numYCells)
        
        //Populate entrance tile
        tiles.append(Array(count: 1, repeatedValue: entranceTile))
        
        currentTilePos = CGPoint(x: 0, y: 0)
        generateEntrance()
        tiles[Int(currentTilePos.y)][Int(currentTilePos.x)] = entranceTile
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
                if Int(currentTilePos.y) == 0
                {
                    //Extend array
                    tiles.insert(Array(count: width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells)), atIndex: 0)
                    nextTile = generateRoomForTile(Int(currentTilePos.x), tileY: 0)
                    tiles[Int(currentTilePos.y)][Int(currentTilePos.x)] = nextTile
                }
                else
                {
                    nextTile = tiles[Int(currentTilePos.y - 1)][Int(currentTilePos.x)]
                    currentTilePos.y -= 1
                }
                
            case .South:
                //If you need a new tile in the south direction
                if Int(currentTilePos.y) == tiles.count - 1
                {
                    //Extend array
                    tiles.append(Array(count: width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells)))
                    nextTile = generateRoomForTile(Int(currentTilePos.x), tileY: Int(currentTilePos.y + 1))
                    tiles[Int(currentTilePos.y + 1)][Int(currentTilePos.x)] = nextTile
                }
                else
                {
                    nextTile = tiles[Int(currentTilePos.y + 1)][Int(currentTilePos.x)]
                }
            
                currentTilePos.y += 1
            
            case .East:
                //If you need a new tile in the east direction
                if Int(currentTilePos.x) == tiles[Int(currentTilePos.y)].count - 1
                {
                    //Extend array
                    setDungeonWidth(width + 1, appendToFront: false)
                    nextTile = generateRoomForTile(Int(currentTilePos.x + 1), tileY: Int(currentTilePos.y))
                    tiles[Int(currentTilePos.y)][Int(currentTilePos.x + 1)] = nextTile
                }
                else
                {
                    nextTile = tiles[Int(currentTilePos.y)][Int(currentTilePos.x + 1)]
                }
                
                currentTilePos.x += 1
            
            case .West:
                //If you need a new tile in the west direction
                if Int(currentTilePos.x) == 0
                {
                    //Extend array
                    setDungeonWidth(width + 1, appendToFront: true)
                    nextTile = generateRoomForTile(0, tileY: Int(currentTilePos.y))
                    tiles[Int(currentTilePos.y)][Int(currentTilePos.x)] = nextTile
                }
                else
                {
                    nextTile = tiles[Int(currentTilePos.y)][Int(currentTilePos.x - 1)]
                    currentTilePos.x -= 1
                }
            
            default:
                return Tile(nXCells: numXCells, nYCells: numYCells)
        }
        
        nextTile.tileSprite = drawTile(Int(currentTilePos.x), y: Int(currentTilePos.y))
        
        return nextTile
    }
    
    func generateEntrance()
    {
        //Roll for entrance
        //Save this so you dont create an exit on the same wall as the entrance
        var entranceDirection : Direction = getDirectionWithWeights(5, southWeight: 5, eastWeight: 5, westWeight: 5)
        var entranceLocation : CGPoint = rollDoorLocationForDirection(entranceDirection)
        
        //Make dungeon entrance
        entranceTile.cells[Int(entranceLocation.y)][Int(entranceLocation.x)] = .Entrance
        entranceCell = CGPoint(x: Int(entranceLocation.x), y: Int(entranceLocation.y))
        
        //Roll for exits
        var numOfExits : Int = Int(arc4random_uniform(3)) + 1    //1 to 3 exits
        
        for c in 0...(numOfExits - 1)
        {
            entranceTile.exitPositions.append(rollDoorLocationForDirection(getDirectionWithWeights((entranceDirection == .North ? 0 : 1), southWeight: (entranceDirection == .South ? 0 : 1), eastWeight: (entranceDirection == .East ? 0 : 1), westWeight: (entranceDirection == .West ? 0 : 1))))
            
            //Make exit
            entranceTile.cells[Int(entranceTile.exitPositions.last!.y)][Int(entranceTile.exitPositions.last!.x)] = .Exit
        }
        
        //Walk from entrance to each exit
        var currentPosition : CGPoint = entranceLocation
        var noise : CGFloat = 50 //The higher the noise the more empty a tile should be
        
        for exit in entranceTile.exitPositions
        {
            while currentPosition != exit
            {
                var nextPosition : CGPoint = getNeighborCellPositionForPositionAndDirection(currentPosition, exitDirection: getDirectionWithWeights((exit.y - currentPosition.y) + noise, southWeight: (currentPosition.y - exit.y) + noise, eastWeight: (exit.x - currentPosition.x) + noise, westWeight: (currentPosition.x - exit.x) + noise))
                
                if isValidCell(nextPosition)
                {
                    entranceTile.cells[Int(nextPosition.y)][Int(nextPosition.x)] = .Empty
                    currentPosition = nextPosition
                }
                else if nextPosition == exit
                {
                    currentPosition = nextPosition
                }
            }
        }
        
        entranceTile.roomGenerated = true
        entranceTile.tileSprite = drawTile(Int(currentTilePos.x), y: Int(currentTilePos.y))
    }

    func generateRoomForTile(tileX : Int, tileY : Int) -> Tile
    {
        var nextTile : Tile = Tile(nXCells: numXCells, nYCells: numYCells)
        var hasNorthExits : Bool = false
        var hasSouthExits : Bool = false
        var hasEastExits : Bool = false
        var hasWestExits : Bool = false
        
        //Add exits from other surrounding already generated tiles
        //Only already generated tiles will have exits
        if tileY > 0
        {
            nextTile.exitPositions += getExitsOnWallForTile(tiles[tileY - 1][tileX], direction: .South)
            hasNorthExits = true
        }
        
        if tileY < tiles.count - 1
        {
            nextTile.exitPositions += getExitsOnWallForTile(tiles[tileY + 1][tileX], direction: .North)
            hasSouthExits = true
        }
        
        if tileX > 0
        {
            nextTile.exitPositions += getExitsOnWallForTile(tiles[tileY][tileX - 1], direction: .East)
            hasWestExits = true
        }
        
        if tileX < width - 1
        {
            nextTile.exitPositions += getExitsOnWallForTile(tiles[tileY][tileX + 1], direction: .West)
            hasEastExits = true
        }
        //
        
        for pos in nextTile.exitPositions
        {
            nextTile.cells[Int(pos.y)][Int(pos.x)] = .Exit
        }
        
        //Roll for exits
        var numOfExits : Int = Int(arc4random_uniform(3)) + 1    //1 to 3 exits
        
        for c in 0...(numOfExits - 1)
        {
            nextTile.exitPositions.append(rollDoorLocationForDirection(getDirectionWithWeights((hasNorthExits ? 0 : 1), southWeight: (hasSouthExits ? 0 : 1), eastWeight: (hasEastExits ? 0 : 1), westWeight: (hasWestExits ? 0 : 1))))
            
            //Make exit
            nextTile.cells[Int(nextTile.exitPositions.last!.y)][Int(nextTile.exitPositions.last!.x)] = .Exit
        }
        
        //Walk from an exit to each other exit
        //Use first exit now, should be exit from last tile
        //Change to use exact exit from last tile later
        var currentPosition : CGPoint = nextTile.exitPositions[0]
        var noise : CGFloat = 50 //The higher the noise the more empty a tile should be
        
        for exit in nextTile.exitPositions
        {
            while currentPosition != exit
            {
                var nextPosition : CGPoint = getNeighborCellPositionForPositionAndDirection(currentPosition, exitDirection: getDirectionWithWeights((exit.y - currentPosition.y) + noise, southWeight: (currentPosition.y - exit.y) + noise, eastWeight: (exit.x - currentPosition.x) + noise, westWeight: (currentPosition.x - exit.x) + noise))
                
                if isValidCell(nextPosition)
                {
                    nextTile.cells[Int(nextPosition.y)][Int(nextPosition.x)] = .Empty
                    currentPosition = nextPosition
                }
                else if nextPosition == exit
                {
                    //cells[Int(nextPosition.y)][Int(nextPosition.x)] = .Exit
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
                tiles[index] = Array(count: dungeonWidth - width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells)) + tiles[index]
            }
            else
            {
                tiles[index] = tiles[index] + Array(count: dungeonWidth - width, repeatedValue: Tile(nXCells: numXCells, nYCells: numYCells))
            }
        }
        
        width = dungeonWidth
    }
    
    func getExitsOnWallForTile(tile : Tile, direction : Direction) -> [CGPoint]
    {
        var exits : [CGPoint] = [CGPoint]()
        
        for exit in tile.exitPositions
        {
            switch direction
            {
                case .North:
                    if Int(exit.y) == numYCells - 1
                    {
                        exits.append(CGPoint(x: exit.x, y: 0))
                    }
                    
                case .South:
                    if Int(exit.y) == 0
                    {
                        exits.append(CGPoint(x: exit.x, y: CGFloat(numYCells - 1)))
                    }
                    
                case .East:
                    if Int(exit.x) == numXCells - 1
                    {
                        exits.append(CGPoint(x: 0, y: exit.y))
                    }
                    
                case .West:
                    if Int(exit.x) == 0
                    {
                        exits.append(CGPoint(x: CGFloat(numXCells - 1), y: exit.y))
                    }
                
                default:
                    debugPrintln("There will never be a diagonal exit")
            }
        }
        
        return exits
    }
    
    func rollDoorLocationForDirection(dir : Direction) -> CGPoint
    {
        var roll : Int!
        
        if dir == .North || dir == .South
        {
            roll = Int(arc4random_uniform(UInt32(numXCells - 2))) + 1
            
            if dir == .South
            {
                return CGPoint(x: roll, y: 0)
            }
            else
            {
                return CGPoint(x: roll, y: numYCells - 1)
            }
        }
        else
        {
            roll = Int(arc4random_uniform(UInt32(numYCells - 2))) + 1
            
            if dir == .West
            {
                return CGPoint(x: 0, y: roll)
            }
            else
            {
                return CGPoint(x: numXCells - 1, y: roll)
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
    
    func getNeighborCellPositionForPositionAndDirection(position : CGPoint, exitDirection : Direction) -> CGPoint
    {
        switch exitDirection
        {
            case .North:
                return CGPoint(x: position.x, y: position.y + 1)
                
            case .South:
                return CGPoint(x: position.x, y: position.y - 1)
                
            case .East:
                return CGPoint(x: position.x + 1, y: position.y)
                
            case .West:
                return CGPoint(x: position.x - 1, y: position.y)
                
            default:
                return CGPoint(x: position.x, y: position.y)
        }
    }
    
    func getNeighborCellForCellAndDirection(cell : Cell, direction : Direction) -> Cell
    {
        switch direction
        {
            case .North:
                return CGPoint(x: position.x, y: position.y + 1)
                
            case .South:
                return CGPoint(x: position.x, y: position.y - 1)
                
            case .East:
                return CGPoint(x: position.x + 1, y: position.y)
                
            case .West:
                return CGPoint(x: position.x - 1, y: position.y)
                
            default:
                return CGPoint(x: position.x, y: position.y)
        }
    }
    
    func getCurrentTile() -> Tile
    {
        return tiles[Int(currentTilePos.y)][Int(currentTilePos.x)]
    }
    
    func screenLocationForIndex(index : CGPoint) -> CGPoint
    {
        return CGPoint(x: (index.x * CGFloat(cellSize!)) + gridLeft, y: (index.y * CGFloat(cellSize!)) + gridBottom)
    }
    
    func cellIndexAtScreenLocation(location : CGPoint) -> CGPoint
    {
        return CGPoint(x: numXCells - 1 - Int(location.x - gridLeft) / cellSize!, y: numYCells - 1 - Int(location.y - gridBottom) / cellSize!)
    }
    
    func cellTypeAtScreenLocation(location : CGPoint) -> Tile.CellType
    {
        var currentTile : Tile = getCurrentTile()

        var xIndex = Int(location.x - gridLeft) / cellSize!
        var yIndex = Int(location.y - gridBottom) / cellSize!

        //If it's not a valid cell position then call it a wall
        if xIndex < 0 || xIndex > numXCells - 1 || yIndex < 0 || yIndex > numYCells - 1
        {
            return .Wall
        }
        
        return currentTile.cells[yIndex][xIndex]
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
    
    func isValidCell(cell : CGPoint) -> Bool
    {
        return (Int(cell.x) >= 1 && Int(cell.x) < numXCells - 1) && (Int(cell.y) >= 1 && Int(cell.y) < numYCells - 1)
    }
}