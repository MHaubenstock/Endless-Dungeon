//
//  Cell.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/25/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class Cell
{
    var index : [Int]
    /*
    enum CellType
    {
        case Entrance
        case Exit
        case Wall
        case Empty
    }
    */
    init(theIndex : [Int])
    {
        if theIndex.count != 2
        {
            debugPrintln("Index should only have 2 elements")
        }

        index = [theIndex[0], theIndex[1]]
    }
    
    func interact()
    {
        
    }
}