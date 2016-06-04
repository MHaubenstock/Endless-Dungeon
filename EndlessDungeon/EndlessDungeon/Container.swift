//
//  Container.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/7/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class Container : Openable
{
    var contents : [Item] = []
    //This is maintained from the contents member and is used mostly for organization in views
    var contentsDict : [Item.Slot : [Item]] = [:]
    var sprite : SKSpriteNode = SKSpriteNode()
    
    var dungeon : Dungeon = Dungeon.sharedInstance
    
    override init()
    {
       
    }
    
    init(numOfItems : Int)
    {
        super.init()
        
        //Add some random items to the container
        for i in 0...numOfItems
        {
            contents.append(Item.randomItem())
        }
        
        maintainContentsDict()
    }
    
    override func open()
    {
        dungeon.containerViewController.open(self)
    }
    
    override func close()
    {
        dungeon.containerViewController.close()
    }
    
    func addItem(item : Item)
    {
        contents.append(item)
        maintainContentsDict()
    }
    
    func removeItem(index : Int) -> Item
    {
        let itemToRemove : Item = contents.removeAtIndex(index)
        
        maintainContentsDict()
        
        return itemToRemove
    }
    
    func maintainContentsDict()
    {
        contentsDict = [:]
        
        for i in contents
        {
            if contentsDict[i.slot] == nil
            {
                contentsDict[i.slot] = []
            }
            
            contentsDict[i.slot]?.append(i)
        }
    }
}