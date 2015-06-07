//
//  Item.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/26/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class Item
{
    var name : String
    var weight : Int
    var CPCost : Int
    var SPCost : Int
    var GPCost : Int
    var PPCost : Int
    
    var slot : Slot
    var size : Size
    var damageDie : Die
    var qntyOfDamageDice : Int
    var damageQuantityDieTypes : [(Int, Die, TypeEnum.DamageType)]
    var range : Int
    var properties : [Property]?
    var armorBonus : Int
    var shieldBonus : Int
    var naturalArmorBonus : Int
    var deflectBonus : Int
    var miscArmorBonus : Int
    var weaponCategory : WeaponCategory
    var weaponType : WeaponType
    var damageType : DamageType
    var armorType : ArmorType
    
    enum Slot : String
    {
        case OneHanded = "One-Handed"
        case TwoHanded = "Two-Handed"
        case Ammo = "Ammo"
        case Head = "Head"
        case Eyes = "Eyes"
        case Neck = "Neck"
        case Torso = "Torso"
        case Body = "Body"
        case Waist = "Waist"
        case Shoulders = "Shoulders"
        case Wrists = "Wrists"
        case Hands = "Hands"
        case Ring = "Ring"
        case Feet = "Feet"
        case None = "None"
    }
    
    enum WeaponCategory
    {
        case Simple
        case Martial
        case Exotic
        case None
    }
    
    enum WeaponType
    {
        case Unarmed
        case Light
        case OneHanded
        case TwoHanded
        case Ranged
        case Shield
        case None
    }
    
    enum DamageType
    {
        case Bludgeoning
        case Piercing
        case Slashing
        case None
    }
    
    enum ArmorType
    {
        case LightArmor
        case MediumArmor
        case HeavyArmor
        case None
    }
    
    init(theSlot : Slot, theSize : Size)
    {
        slot = theSlot
        size = theSize
        name = "Some Item"
        weight = 0
        CPCost = 0
        SPCost = 0
        GPCost = 0
        PPCost = 0
        damageDie = .None
        qntyOfDamageDice = 0
        damageQuantityDieTypes = []
        range = 0
        weaponCategory = .None
        weaponType = .None
        damageType = .None
        armorType = .None
        armorBonus = 0
        shieldBonus = 0
        naturalArmorBonus = 0
        deflectBonus = 0
        miscArmorBonus = 0
    }
    
    //For initializing a weapon
    init(theName : String, theSlot : Slot, theSize : Size, damDie : Die, dieQnty : Int, theRange: Int, theWeapCat : WeaponCategory, theWeaponType : WeaponType, theDamType : DamageType)
    {
        name = theName
        weight = 0
        CPCost = 0
        SPCost = 0
        GPCost = 0
        PPCost = 0
        slot = theSlot
        size = theSize
        damageDie = damDie
        range = theRange
        qntyOfDamageDice = dieQnty
        damageQuantityDieTypes = [(dieQnty, damDie, .Normal)]
        weaponCategory = theWeapCat
        weaponType = theWeaponType
        damageType = theDamType
        armorType = .None
        armorBonus = 0
        shieldBonus = 0
        naturalArmorBonus = 0
        deflectBonus = 0
        miscArmorBonus = 0
    }
    
    //For initializing armor
    init(theName : String, theSlot : Slot, theSize : Size, aBonus : Int, sBonus : Int, naBonus : Int, dBonus : Int, maBonus : Int, theArmType : ArmorType)
    {
        name = theName
        weight = 0
        CPCost = 0
        SPCost = 0
        GPCost = 0
        PPCost = 0
        slot = theSlot
        size = theSize
        damageDie = .None
        qntyOfDamageDice = 0
        damageQuantityDieTypes = []
        range = 0
        weaponCategory = .None
        weaponType = .None
        damageType = .None
        armorType = theArmType
        armorBonus = aBonus
        shieldBonus = sBonus
        naturalArmorBonus = naBonus
        deflectBonus = dBonus
        miscArmorBonus = maBonus
    }
    
    func upgradeItem(property : Property)
    {
        properties?.append(property)
    }
    
    class func emptyItem() -> Item
    {
        return Item(theSlot: .None, theSize: .Medium)
    }
    
    class func shortSword() -> Item
    {
        return Item(theName: "Short Sword", theSlot: .OneHanded, theSize: .Medium, damDie: .d6, dieQnty: 1, theRange: 1, theWeapCat: .Simple, theWeaponType: .Light, theDamType: .Slashing)
    }
    
    class func shortBow() -> Item
    {
        return Item(theName: "Shortbow", theSlot: .TwoHanded, theSize: .Medium, damDie: .d6, dieQnty: 1, theRange: 6, theWeapCat: .Simple, theWeaponType: .Ranged, theDamType: .Slashing)
    }
    
    class func leatherArmor() -> Item
    {
        return Item(theName: "Leather Armor", theSlot: .Body, theSize: .Medium, aBonus: 2, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
    }
    
    class func shield() -> Item
    {
        return Item(theName: "Light Wooden Shield", theSlot: .OneHanded, theSize: .Medium, damDie: .None, dieQnty: 0, theRange: 1, theWeapCat: .None, theWeaponType: .OneHanded, theDamType: .Bludgeoning)
    }
    
    class func randomItem() -> Item
    {
        var itemCreationFunctions : [() -> Item] = [shortBow, shortSword]
        
        return arc4random_uniform(10) > 5 ? itemCreationFunctions[0]() : itemCreationFunctions[1]()
    }
}
