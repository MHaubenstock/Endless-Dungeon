//
//  NPCDungeonState.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/16/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class NPCTurnState
{
    var movementRemaining : Int
    var npcTilePosition : (Int, Int)
    var weaponRange : Int
    var tileCellStates : [[Int]]
    var stateValue : Int
    var moveDirection : Dungeon.Direction?
    var fromState : NPCTurnState?
    
    init(movementRem : Int, tilePos : (Int, Int), weapRange : Int, cellState : [[Int]], fState : NPCTurnState?)
    {
        movementRemaining = movementRem
        npcTilePosition = tilePos
        weaponRange = weapRange
        tileCellStates = cellState
        
        if fState != nil
        {
            fromState = fState
        }
        
        //Evaluate the state
        stateValue = 0
        var foundPlayer : Bool = false
        
        //State value equals movementRemaining + whether enemy is in range to attack player
        for x in 0...(tileCellStates[0].count - 1)
        {
            for y in 0...(tileCellStates.count - 1)
            {
                if(tileCellStates[y][x] == 1)
                {
                    stateValue += Dungeon.distanceBetweenCellsByIndex((y, x), toIndex: npcTilePosition)
                    
                    //If within range to attack player
                    if Dungeon.distanceBetweenCellsByIndex(npcTilePosition, toIndex: (x, y)) <= weaponRange
                    {
                        //stateValue += (movementRemaining + 1) * 2   //Maybe increase the 2 later
                        stateValue += 20
                    }
                    
                    foundPlayer = true
                    break
                }
            }
            
            if foundPlayer
            {
                break
            }
        }
    }
    
    /*
    func evaluateState() -> Int
    {
        var stateValue : Int = movementRemaining
        var foundPlayer : Bool = false
        
        //State value equals movementRemaining + whether enemy is in range to attack player
        for x in 0...(tileCellStates.count - 1)
        {
            for y in 0...(tileCellStates[0].count - 1)
            {
                //If within range to attack player
                if(tileCellStates[y][x] == 1 && Dungeon.distanceBetweenCellsByIndex(npcTilePosition, toIndex: (x, y)) <= weaponRange)
                {
                    stateValue += (movementRemaining + 1) * 2   //Maybe increase the 2 later
                    
                    foundPlayer = true
                    break
                }
            }
            
            if foundPlayer
            {
                break
            }
        }
        
        return stateValue
    }
    */
    
    func getNextStates() -> [NPCTurnState]
    {
        var nextStates : [NPCTurnState] = []
        var nextPossiblePositions : [((Int, Int), Dungeon.Direction)] = [((npcTilePosition.0, npcTilePosition.1 - 1), Dungeon.Direction.South), ((npcTilePosition.0, npcTilePosition.1 + 1), Dungeon.Direction.North), ((npcTilePosition.0 + 1, npcTilePosition.1), Dungeon.Direction.East), ((npcTilePosition.0 - 1, npcTilePosition.1), Dungeon.Direction.West)]
        var dungeon : Dungeon = Dungeon.sharedInstance
        
        for p in nextPossiblePositions
        {
            var cellType : Cell.CellType = dungeon.getCurrentTile().cells[p.0.1][p.0.0].cellType
            
            if(isValidIndex(p.0) && cellType != Cell.CellType.Wall && cellType != Cell.CellType.Exit && cellType != Cell.CellType.Entrance)
            {
                //If the cell is empty then this is a possible move
                if(tileCellStates[p.0.1][p.0.0] == 3)
                {
                    var newCellState : [[Int]] = tileCellStates
                    
                    //Swap enemy position to new position
                    tileCellStates[p.0.1][p.0.0] = 4
                    //Make old position empty
                    tileCellStates[npcTilePosition.1][npcTilePosition.0] = 3
                    
                    var turnState : NPCTurnState = NPCTurnState(movementRem: movementRemaining - 1, tilePos: p.0, weapRange: weaponRange, cellState: newCellState, fState: self)
                    turnState.moveDirection = p.1
                    
                    nextStates.append(turnState)
                }
            }
        }
        
        return nextStates
    }
    
    func isValidIndex(index : (Int, Int)) -> Bool
    {
        return (index.0 >= 0 && index.1 >= 0 && index.0 < tileCellStates[0].count && index.1 < tileCellStates.count)
    }
}