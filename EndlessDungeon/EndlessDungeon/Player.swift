//
//  Player.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/24/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class Player
{
    var name : String!
    var sprite : SKSpriteNode!
    
    //Character stats
    var strength : Int!
    var dexterity : Int!
    var constitution : Int!
    var intelligence : Int!
    var wisdom : Int!
    var charisma : Int!
    var strengthBonus : Int!
    var dexterityBonus : Int!
    var constitutionBonus : Int!
    var intelligenceBonus : Int!
    var wisdomBonus : Int!
    var charismaBonus : Int!
    var armorClass : Int!
    var speed : Int!
    var hitPoints : Int!
    var currentHitPoints : Int!
    var hitDice : Die!
    var actionPoints : Int!
    var baseFortitude : Int!
    var baseReflex : Int!
    var baseWill : Int!
    var baseAttackBonus : [Int]!
    var skillRanks : [Skill : Int]!
    
    //Equipment
    var leftHand : EquippableItem!
    var rightHand : EquippableItem!
    var head : EquippableItem!
    var body : EquippableItem!
    var shoulders : EquippableItem!
    var hands : EquippableItem!
    var wrists : EquippableItem!
    var feet : EquippableItem!
    var ammo : EquippableItem!
    var platinum : Int!
    var gold : Int!
    var silver : Int!
    var copper : Int!

    
    var miscellaneousSkillModifiers : [Skill : Int]!
    
    
    //Character Traits
    var experience : Int!
    var race : Race!
    var characterClass : String!
    var alignment : Alignment!
    var size : Size!
    var languages : [String]!
    var gender : String!
    var height : String!
    var weight : Int!
    var eyes : String!
    var hair : String!
    
    
    
    init(playerName : String)
    {
        name = playerName
        rollCharacter(1)
    }
    
    func rollCharacter(level : Int) //Right now just creates a first level character regardless of level value passed in
    {
        experience = 0
        race = .Human
        characterClass = "Thief"
        size = .Medium
        alignment = .Neutral
        languages = ["Common"]
        
        strength = rollStat()
        dexterity = rollStat()
        constitution = rollStat()
        intelligence = rollStat()
        wisdom = rollStat()
        charisma = rollStat()
        
        strengthBonus = calculateBonus(strength)
        dexterityBonus = calculateBonus(dexterity)
        constitutionBonus = calculateBonus(constitution)
        intelligenceBonus = calculateBonus(intelligence)
        wisdomBonus = calculateBonus(wisdom)
        charismaBonus = calculateBonus(charisma)
        
        armorClass = 10
        speed = 30
        hitDice = .d6
        hitPoints = rollDie(level, die: hitDice) + constitutionBonus * level
        currentHitPoints = hitPoints
        actionPoints = level + 3
        baseFortitude = 0
        baseReflex = 2
        baseWill = 0
        baseAttackBonus = [0]
        skillRanks = [Skill : Int]()
        miscellaneousSkillModifiers = [Skill : Int]()
        
        platinum = 0
        gold = 100
        silver = 0
        copper = 0
        
        gender = "Male"
        height = "5\" 11'"
        weight = 120
        hair = "Grey"
        eyes = "Grey"
        
        rightHand = EquippableItem(theSlot: .None, theSize: .Medium, damDie: .d3, dieQnty: 1, theWeapCat: .Simple, theWeaponType: .Unarmed, theDamType: .Bludgeoning, theArmType: .None)
        
        leftHand = EquippableItem(theSlot: .None, theSize: .Medium, damDie: .d3, dieQnty: 1, theWeapCat: .Simple, theWeaponType: .Unarmed, theDamType: .Bludgeoning, theArmType: .None)
        
        head = EquippableItem(theSlot: .Head, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .LightArmor)
        
        body = EquippableItem(theSlot: .Body, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .LightArmor)
        
        shoulders = EquippableItem(theSlot: .Shoulders, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .None)
        
        hands = EquippableItem(theSlot: .Hands, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .LightArmor)
        
        wrists = EquippableItem(theSlot: .Wrists, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .LightArmor)
        
        feet = EquippableItem(theSlot: .Feet, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .LightArmor)
        
        ammo = EquippableItem(theSlot: .None, theSize: .Medium, damDie: .None, dieQnty: 0, theWeapCat: .None, theWeaponType: .None, theDamType: .None, theArmType: .None)
    }

    func updateCharacterSheet()
    {
        
    }
    
    func rollStat() -> Int
    {
        //Roll a d6 four times and return the result of the highest three summed together
        var rolls : [Int] = [Int]()
        
        for var r : Int = 0; r < 4; ++r
        {
            rolls.append(rollDie(1, die: .d6))
        }
        
        //Sort in descending order
        rolls.sorted{$0 > $1}
        
        //return the sum of the largest 3 values
        return rolls[0] + rolls[1] + rolls[2]
    }
    
    func calculateBonus(stat : Int) -> Int
    {
        return stat / 2 - 5
    }
    
    func equipItem(item : EquippableItem)
    {
        switch item.slot
        {
            case .OneHanded:
                
                //If holding a two handed weapon
                if rightHand.slot == EquippableItem.Slot.TwoHanded
                {
                    //Unequip two handed weapon and equip new item in right hand
                }
                //If unarmed
                else if rightHand.slot == .None
                {
                    //Equip in right hand
                }
                //if holding one handed weapon in right hand
                else if rightHand.slot == .OneHanded
                {
                    //Equip in left hand
                }
                //holding one handed weapon in both hands
                else if rightHand.slot == .OneHanded && leftHand.slot == .OneHanded
                {
                    //Equip in left hand
                }
            
            case .TwoHanded:
            
                //Unequip weapons and equip two handed weapon in right hand
                leftHand = EquippableItem.emptyItem()
                rightHand = item
            
            case .Ammo:
            
                ammo = item
            
            case .Body:
            
                body = item
            
            case .Shoulders:
            
                shoulders = item
            
            case .Head:
            
                head = item
            
            case .Hands:
            
                hands = item
            
            case .Wrists:
            
                wrists = item
            
            case .Feet:
            
                feet = item
            
            case .None:
            
                if leftHand.slot != .None
                {
                    leftHand = item
                }
                else
                {
                    rightHand = item
                }
        }
        
        updateCharacterSheet()
    }
    
    //This might not be needed
    func unequipItem(theSlot : EquippableItem.Slot)//item : EquippableItem)
    {
        
    }
    //
    
    func rollDie(qnty : Int, die : Die) -> Int
    {
        var total : Int = 0
        
        for var r : Int = 0; r < qnty; ++r
        {
            switch die
            {
                case .d2:
                    total += Int(arc4random_uniform(2)) + 1
                
                case .d3:
                    total += Int(arc4random_uniform(3)) + 1
                
                case .d4:
                    total += Int(arc4random_uniform(4)) + 1
                
                case .d6:
                    total += Int(arc4random_uniform(6)) + 1
                
                case .d8:
                    total += Int(arc4random_uniform(8)) + 1
                
                case .d10:
                    total += Int(arc4random_uniform(10)) + 1
                
                case .d12:
                    total += Int(arc4random_uniform(12)) + 1
                
                case .d20:
                    total += Int(arc4random_uniform(20)) + 1
                
                case .dPercent:
                    total += Int(arc4random_uniform(100)) + 1
                
                case .None:
                    total += 0
            }
        }
        
        return total
    }
}
