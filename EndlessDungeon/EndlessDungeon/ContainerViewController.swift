//
//  ContainerViewController.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/9/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class ContainerViewController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var container : Container
    var dungeon : Dungeon = Dungeon.sharedInstance
    @IBOutlet var itemTable: UITableView!
    
    init()
    {
        container = Container()
        
        super.init(nibName: "ContainerView", bundle: nil)
        
        //Modify frame size so it looks like a loot window
        view.frame = CGRect(x: dungeon.frame.size.width * 0.4, y: dungeon.frame.size.height * 0.1, width: dungeon.frame.size.width * 0.25, height: dungeon.frame.size.height * 0.6)
        view.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func open(theContainer : Container)
    {
        //Close any already open container
        container.isOpen = false
        
        //Show view with this containers data
        container = theContainer
        
        container.isOpen = true
        
        itemTable.reloadData()
        
        self.view.hidden = false
    }
    
    func close()
    {
        container.isOpen = false
        self.view.hidden = true
    }
    
    //Table stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        tableView.registerNib(UINib(nibName: "ContainerCell", bundle: nil), forCellReuseIdentifier: "ContainerCell")
        
        var numOfCells = 0

        return container.contents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContainerCell") as! UITableViewCell
        //cell.textLabel?.text = container.contents[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        dungeon.player.addItemToInventory(container.removeItem(indexPath.row))
        tableView.reloadData()
    }
    //
}
