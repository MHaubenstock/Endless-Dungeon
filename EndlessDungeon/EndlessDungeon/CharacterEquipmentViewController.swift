//
//  InventoryViewController.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/9/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class CharacterEquipmentViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var player : Player = Player()
    var dungeon : Dungeon = Dungeon.sharedInstance
    
    //For when i do dragging
    var draggedViewFrame : CGRect!
    var draggedCell : UICollectionViewCell!
    var dragImageView : UIImageView!
    //
    
    //For highlight equipping
    var highlightedCell : UICollectionViewCell?
    //
    
    
    @IBOutlet var itemView : UICollectionView!
    @IBOutlet var leftHandSlot : UIImageView!
    @IBOutlet var rightHandSlot : UIImageView!
    @IBOutlet var headSlot : UIImageView!
    @IBOutlet var bodySlot : UIImageView!
    @IBOutlet var shoulderSlot : UIImageView!
    @IBOutlet var handSlot : UIImageView!
    @IBOutlet var wristSlot : UIImageView!
    @IBOutlet var feetSlot : UIImageView!
    @IBOutlet var waistSlot : UIImageView!
    @IBOutlet var torsoSlot : UIImageView!
    @IBOutlet var eyeSlot : UIImageView!
    @IBOutlet var ring1Slot : UIImageView!
    @IBOutlet var ring2Slot : UIImageView!
    @IBOutlet var neckSlot : UIImageView!
    @IBOutlet var ammoSlot : UIImageView!
    @IBOutlet var itemLabel : UILabel!
    
    override init()
    {
        super.init(nibName: "CharacterEquipmentView", bundle: nil)

        view.frame = dungeon.frame
        
        //Set up collection view stuff
        var leftHandSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var rightHandSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var headSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var bodySlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var shoulderSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var handSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var wristSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var feetSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var waistSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var torsoSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var eyesSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var ring1SlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var ring2SlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var neckSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))
        var ammoSlotTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: ("equipItem:"))

        leftHandSlot.addGestureRecognizer(leftHandSlotTapGesture)
        rightHandSlot.addGestureRecognizer(rightHandSlotTapGesture)
        headSlot.addGestureRecognizer(headSlotTapGesture)
        bodySlot.addGestureRecognizer(bodySlotTapGesture)
        shoulderSlot.addGestureRecognizer(shoulderSlotTapGesture)
        handSlot.addGestureRecognizer(handSlotTapGesture)
        wristSlot.addGestureRecognizer(wristSlotTapGesture)
        feetSlot.addGestureRecognizer(feetSlotTapGesture)
        waistSlot.addGestureRecognizer(waistSlotTapGesture)
        torsoSlot.addGestureRecognizer(torsoSlotTapGesture)
        eyeSlot.addGestureRecognizer(eyesSlotTapGesture)
        ring1Slot.addGestureRecognizer(ring1SlotTapGesture)
        ring2Slot.addGestureRecognizer(ring2SlotTapGesture)
        neckSlot.addGestureRecognizer(neckSlotTapGesture)
        ammoSlot.addGestureRecognizer(ammoSlotTapGesture)
        
        var itemCollectionDragGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("dragItem:"))
        itemView.addGestureRecognizer(itemCollectionDragGesture)
        
        
        var itemViewFlowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemViewFlowLayout.itemSize = CGSize(width: itemView.frame.width * 0.25, height: itemView.frame.height * 0.05)
        itemViewFlowLayout.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        itemView.collectionViewLayout = itemViewFlowLayout
        
        //Manually align the slot views here
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func open(thePlayer : Player)
    {
        //Show view with this containers data
        player = thePlayer
        
        itemView.reloadData()
        
        self.view.hidden = false
    }
    
    func close()
    {
        self.view.hidden = true
    }
    
    func equipItem(gesture : UITapGestureRecognizer)
    {
        if(highlightedCell != nil)
        {
            var theVeiw : UIView? = view.hitTest(gesture.locationInView(view), withEvent: nil)

            if(theVeiw != nil)
            {
                if(theVeiw is UIImageView)
                {
                    //If item.slot == clicked slot
                    debugPrintln(highlightedCell)
                    player.equipItem(player.inventory.contents[itemView.indexPathForCell(highlightedCell!)!.row])
                    debugPrintln("Equipped an item")
                }
            }
        }
    }
    
    func dragItem(gesture : UILongPressGestureRecognizer)
    {
        /*
        //Start drag
        if(gesture.state == UIGestureRecognizerState.Began)
        {
            var cellIndexPath : NSIndexPath? = itemView.indexPathForItemAtPoint(gesture.locationInView(itemView))
            
            if(cellIndexPath != nil)
            {
                draggedCell = itemView.cellForItemAtIndexPath(cellIndexPath!)
                dragImageView = draggedCell.viewWithTag(1) as UIImageView
                draggedViewFrame = dragImageView.frame
                draggedViewFrame.origin = gesture.locationInView(draggedCell)
                
                dragImageView.frame = draggedViewFrame
            }
        }
        //Continue drag
        else if(gesture.state == UIGestureRecognizerState.Changed)
        {
            draggedViewFrame.origin = gesture.locationInView(draggedCell)
            dragImageView.frame = draggedViewFrame
        }
        //Finish drag
        else if(gesture.state == UIGestureRecognizerState.Ended)
        {
            //If inside the correct slot
            for v in view.subviews
            {
                if(v.pointInside(gesture.locationInView(draggedCell), withEvent: nil))
                {
                    debugPrintln(v)
                }
            }
            
            dragImageView = nil
        }
        */
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        for touch : AnyObject in touches
        {
            //let location = touch.locationInNode(self)
            //let touchedNode = self.nodeAtPoint(location)
            let location = touch.locationInView(self.view)
            let collectionLocation = touch.locationInView(itemView)
            //let touchedView =
        }
    }
    
    //Collection view stuff
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        collectionView.registerNib(UINib(nibName: "CharacterInventoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "InventoryItemCell")
        return player.inventory.contents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var itemCell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InventoryItemCell", forIndexPath: indexPath) as UICollectionViewCell
        
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        highlightedCell = collectionView.cellForItemAtIndexPath(indexPath)
        itemLabel.text = player.inventory.contents[indexPath.row].name
        debugPrintln(highlightedCell)
    }
    //
}