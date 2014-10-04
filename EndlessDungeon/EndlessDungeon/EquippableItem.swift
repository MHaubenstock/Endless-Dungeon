//
//  EquippableItem.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/26/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class EquippableItem : Item
{
    var slot : Slot
    var size : Size
    var damageDie : Die
    var qntyOfDamageDice : Int
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
    
    init(theSlot : Slot, theSize : Size, damDie : Die, dieQnty : Int, theWeapCat : WeaponCategory, theWeaponType : WeaponType, theDamType : DamageType, theArmType : ArmorType)
    {
        slot = theSlot
        size = theSize
        damageDie = damDie
        qntyOfDamageDice = dieQnty
        weaponCategory = theWeapCat
        weaponType = theWeaponType
        damageType = theDamType
        armorType = theArmType
    }
    
    class func emptyItem() -> EquippableItem
    {
        return EquippableItem(theSlot: .None, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .None)
    }
}