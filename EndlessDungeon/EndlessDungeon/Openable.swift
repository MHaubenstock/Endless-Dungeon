//
//  Openable.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/9/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class Openable : WorldObject
{
    var isOpen : Bool = false
    
    override init()
    {
        
    }
    
    func open()
    {
        isOpen = true
    }
    
    func close()
    {
        isOpen = false
    }
}
