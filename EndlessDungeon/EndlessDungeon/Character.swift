//
//  Character.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/9/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

class Character : WorldObject
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
    var miscellaneousSkillModifiers : [Skill : Int]!
    
    //Equipment
    //Make these a dictionary
    /*
    var leftHand : Item!
    var rightHand : Item!
    var head : Item!
    var body : Item!
    var shoulders : Item!
    var hands : Item!
    var wrists : Item!
    var feet : Item!
    var waist : Item!
    var torso : Item!
    var eyes : Item!
    var ring1 : Item!
    var ring2 : Item!
    var neck : Item!
    var ammo : Item!
    */
    var leftHand : Item!
    var rightHand : Item!
    var head : Item!
    var body : Item!
    var shoulders : Item!
    var hands : Item!
    var wrists : Item!
    var feet : Item!
    var waist : Item!
    var torso : Item!
    var eyes : Item!
    var ring1 : Item!
    var ring2 : Item!
    var neck : Item!
    var ammo : Item!
    var platinum : Int!
    var gold : Int!
    var silver : Int!
    var copper : Int!
    
    
    var inventory : Container!
    
    
    
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
    var eyeColor : String!
    var hairColor : String!
    
    
    //Character status
    var unconscious : Bool = false
    var dead : Bool = false
    
    override init()
    {
        super.init()
        
        name = "Empty Player"
        rollCharacter(1)
    }
    
    init(playerName : String)
    {
        super.init()
        
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
        
        armorClass = 10 + dexterityBonus
        speed = 30
        hitDice = .d6
        
        //Minimum 1 hp per level
        var hp : Int
        hitPoints = 0
        for l in 1...level
        {
            hp = rollDie(1, die: hitDice) + constitutionBonus * level
            hp = (hp >= 1 ? hp : 1)
            hitPoints = hitPoints + hp
        }
        
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
        height = "5\" 6'"
        weight = 120
        hairColor = "Grey"
        eyeColor = "Grey"
        
        rightHand = Item(theName: "Empty Hand", theSlot: .None, theSize: .Medium, damDie: .d3, dieQnty: 1, theRange: 1, theWeapCat: .Simple, theWeaponType: .Unarmed, theDamType: .Bludgeoning)
        
        leftHand = Item(theName: "Empty Hand", theSlot: .None, theSize: .Medium, damDie: .d3, dieQnty: 1, theRange: 1, theWeapCat: .Simple, theWeaponType: .Unarmed, theDamType: .Bludgeoning)
        
        head = Item(theName: "Empty Head", theSlot: .Head, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        body = Item(theName: "Empty Body", theSlot: .Body, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        torso = Item(theName: "Empty Torso", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None)
        
        shoulders = Item(theName: "Empty Shoulders", theSlot: .Shoulders, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        hands = Item(theName: "Empty Gloves", theSlot: .Hands, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        wrists = Item(theName: "Empty Wrists", theSlot: .Wrists, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        feet = Item(theName: "Empty Feet", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        waist = Item(theName: "Empty Waist", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        eyes = Item(theName: "Empty Eyes", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None)
        
        neck = Item(theName: "Empty Neck", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None)
        
        ring1 = Item(theName: "Empty Ring", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None)
        
        ring2 = Item(theName: "Empty Ring", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None)
        
        ammo = Item(theName: "Empty Ammo", theSlot: .None, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor)
        
        inventory = Container()
    }
    
    func updateCharacterSheet()
    {
        //Recalculate stat bonuses
        strengthBonus = calculateBonus(strength)
        dexterityBonus = calculateBonus(dexterity)
        constitutionBonus = calculateBonus(constitution)
        intelligenceBonus = calculateBonus(intelligence)
        wisdomBonus = calculateBonus(wisdom)
        charismaBonus = calculateBonus(charisma)
        
        //Add bonuses from armor
        armorClass = 10 + dexterityBonus + totalArmorClassBonus()
        //Need to do stuff for hit points
        //hitPoints =
        //This is an empty method at the moment
        calculateSkillModifiers()
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
    
    //Returns amount of damage done
    func attackCharacter(character : Character, weapon : Item) -> Int
    {
        var attack : Int = 0
        
        //If the attack hits
        if(character.armorClass <= rollAttack((weapon.weaponType == Item.WeaponType.Ranged ? dexterityBonus : strengthBonus), baseAttackBonus: baseAttackBonus[0]))
        {
            //Roll Damage
            return rollDamage(weapon)
        }
        
        //You missed!
        return 0
    }
    
    func rollAttack(abilityBonus : Int, baseAttackBonus : Int) -> Int
    {
        return rollDie(1, die: .d20) + abilityBonus + baseAttackBonus
    }
    
    func rollDamage(weapon : Item) -> Int
    {
        var dam : Int = rollDie(weapon.qntyOfDamageDice, die: weapon.damageDie) + (weapon.weaponType != .Ranged ? strengthBonus : 0)
        
        return (dam > 0 ? dam : 1)
    }
    
    func takeDamage(damage : Int)
    {
        currentHitPoints = currentHitPoints - damage
        
        //Create damage label above player
        displayFadeAwayLabel(String(-damage), color: (damage > 0 ? UIColor.redColor() : UIColor.darkGrayColor()))
        
        debugPrintln("Took " + String(damage) + " damage : " + String(currentHitPoints) + " hit points left")
        
        if(currentHitPoints <= 0)
        {
            unconscious = true
            
            if(currentHitPoints <= -10)
            {
                dead = true
            }
        }
    }
    
    func displayFadeAwayLabel(text : String, color : UIColor)
    {
        //create action to make label move up and disappear
        var label : SKLabelNode = SKLabelNode(text: text)
        label.position = CGPoint(x: 15, y: 20)
        label.fontColor = color
        label.fontSize = 12
        label.fontName = "Kenzo Regular"
        
        label.runAction(SKAction.moveByX(0, y: 20, duration: 1.25), completion: {
            self.sprite.removeChildrenInArray([label])
            
        })
        
        label.runAction(SKAction.fadeOutWithDuration(1.25))
        
        sprite.addChild(label)
    }
    
    func calculateBonus(stat : Int) -> Int
    {
        return stat / 2 - 5
    }
    
    func openOpenable(openable : Openable)
    {
        openable.open()
    }
    
    func closeOpenable(openable : Openable)
    {
        openable.close()
    }
    
    func addItemToInventory(item : Item)
    {
        inventory.addItem(item)
    }
    
    func equipItem(item : Item, toPlayerSlot : Item)
    {
        
    }
    
    func equipItem(item : Item)
    {
        switch item.slot
            {
        case .OneHanded:
            
            //If holding a two handed weapon
            if rightHand.slot == Item.Slot.TwoHanded
            {
                //Unequip two handed weapon and equip new item in right hand
                leftHand = Item.emptyItem()
                rightHand = item
            }
                //If unarmed
            else if rightHand.slot == .None
            {
                //Equip in right hand
                rightHand = item
            }
                //if holding one handed weapon in right hand
            else if rightHand.slot == .OneHanded
            {
                //Equip in left hand
                leftHand = item
            }
                //holding one handed weapon in both hands
            else if rightHand.slot == .OneHanded && leftHand.slot == .OneHanded
            {
                //Equip in left hand
                leftHand = item
            }
            
        case .TwoHanded:
            
            //Unequip weapons and equip two handed weapon in right hand
            leftHand = Item.emptyItem()
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
            
        case .Eyes:
            
            eyes = item
            
        case .Neck:
            
            neck = item
            
        case .Torso:
            
            torso = item
            
        case .Waist:
            
            waist = item
            
        case .Ring:
            
            ring1 = item
            
            //Add in ring 2 stuff
            
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
    func unequipItem(item : Item)
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
    
    func totalArmorClassBonus() -> Int
    {
        var highestABonus : Int = 0
        var highestSBonus : Int = 0
        var highestNABonus : Int = 0
        var highestDBonus : Int = 0
        var highestMABonus : Int = 0
        var eItems : [Item] = [leftHand, rightHand, head, body, shoulders, hands, wrists, feet, waist, torso, eyes, ring1, ring2, neck, ammo]
        
        for i in eItems
        {
            highestABonus = max(highestABonus, i.armorBonus)
            highestSBonus = max(highestSBonus, i.shieldBonus)
            highestNABonus = max(highestNABonus, i.naturalArmorBonus)
            highestSBonus = max(highestSBonus, i.shieldBonus)
            highestMABonus = max(highestMABonus, i.miscArmorBonus)
        }
        
        return highestABonus + highestDBonus + highestMABonus + highestNABonus + highestSBonus
    }
    
    func calculateSkillModifiers()
    {
        
    }
}