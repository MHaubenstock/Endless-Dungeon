//
//  Cell.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/25/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class Cell
{
    var index : (Int, Int)
    var cellType : CellType
    var cellImage : String
    var position : CGPoint
    
    enum CellType
    {
        case Entrance
        case Exit
        case Wall
        case Empty
    }
    
    init()
    {
        index = (0, 0)
        cellType = .Wall
        position = CGPoint(x: 0, y: 0)
        cellImage = "UnexcevetedTile.png"
    }
    
    init(theIndex : (Int, Int))
    {
        index = theIndex
        cellType = .Wall
        position = CGPoint(x: 0, y: 0)
        cellImage = "UnexcevetedTile.png"
    }
    
    init(type : CellType)
    {
        index = (0, 0)
        cellType = type
        position = CGPoint(x: 0, y: 0)
        cellImage = "UnexcevetedTile.png"
    }
    
    init(theIndex : (Int, Int), type : CellType)
    {
        index = theIndex
        cellType = type
        position = CGPoint(x: 0, y: 0)
        cellImage = "UnexcevetedTile.png"
    }
    
    init (type : CellType, thePosition : CGPoint)
    {
        index = (0, 0)
        cellType = type
        position = thePosition
        cellImage = "UnexcevetedTile.png"
    }
    
    init (theIndex : (Int, Int), type : CellType, thePosition : CGPoint)
    {
        index = theIndex
        cellType = type
        position = thePosition
        cellImage = "UnexcevetedTile.png"
    }
    
    func interact()
    {
        
    }
}