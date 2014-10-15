//
//  DungeonMaster.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/11/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

//This class runs the game
//For now, it handles player and enemy turns and enemy ai

import Foundation

class DungeonMaster
{
    var dungeon : Dungeon
    
    var activeCharacter : Character
    var usedMinorAction : Bool
    var usedMoveAction : Bool
    var squaresMoved : Int
    var usedStandardAction : Bool
    
    init()
    {
        dungeon = Dungeon.sharedInstance
        
        activeCharacter = dungeon.player
        usedMinorAction = false
        usedMoveAction = false
        squaresMoved = 0
        usedStandardAction = false
    }
    
    
}