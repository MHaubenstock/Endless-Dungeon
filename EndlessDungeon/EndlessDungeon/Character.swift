//
//  Character.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/9/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation
import SpriteKit

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

class Character : WorldObject
{
    var name : String!
    var sprite : SKSpriteNode!
    var tilePosition : (Int, Int)!
    
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
    var leftHand : (Item!, [Item.Slot])!
    var rightHand : (Item!, [Item.Slot])!
    var head : (Item!, [Item.Slot])!
    var body : (Item!, [Item.Slot])!
    var shoulders : (Item!, [Item.Slot])!
    var hands : (Item!, [Item.Slot])!
    var wrists : (Item!, [Item.Slot])!
    var feet : (Item!, [Item.Slot])!
    var waist : (Item!, [Item.Slot])!
    var torso : (Item!, [Item.Slot])!
    var eyes : (Item!, [Item.Slot])!
    var ring1 : (Item!, [Item.Slot])!
    var ring2 : (Item!, [Item.Slot])!
    var neck : (Item!, [Item.Slot])!
    var ammo : (Item!, [Item.Slot])!
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
        sprite = SKSpriteNode()
    }
    
    init(playerName : String)
    {
        super.init()
        
        name = playerName
        rollCharacter(1)
        sprite = SKSpriteNode()
    }
    
    init(playerName : String, level : Int)
    {
        super.init()
        
        name = playerName
        rollCharacter(level)
        sprite = SKSpriteNode()
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
        
        rightHand = (Item(theName: "Empty Hand", theSlot: .None, theSize: .Medium, damDie: .d3, dieQnty: 1, theRange: 1, theWeapCat: .Simple, theWeaponType: .Unarmed, theDamType: .Bludgeoning), [.OneHanded, .TwoHanded])
        
        leftHand = (Item(theName: "Empty Hand", theSlot: .None, theSize: .Medium, damDie: .d3, dieQnty: 1, theRange: 1, theWeapCat: .Simple, theWeaponType: .Unarmed, theDamType: .Bludgeoning), [.OneHanded, .TwoHanded])
        
        head = (Item(theName: "Empty Head", theSlot: .Head, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Head])
        
        body = (Item(theName: "Empty Body", theSlot: .Body, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Body])
        
        torso = (Item(theName: "Empty Torso", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None), [.Torso])
        
        shoulders = (Item(theName: "Empty Shoulders", theSlot: .Shoulders, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Shoulders])
        
        hands = (Item(theName: "Empty Gloves", theSlot: .Hands, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Hands])
        
        wrists = (Item(theName: "Empty Wrists", theSlot: .Wrists, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Wrists])
        
        feet = (Item(theName: "Empty Feet", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Feet])
        
        waist = (Item(theName: "Empty Waist", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Waist])
        
        eyes = (Item(theName: "Empty Eyes", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None), [.Eyes])
        
        neck = (Item(theName: "Empty Neck", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None), [.Neck])
        
        ring1 = (Item(theName: "Empty Ring", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None), [.Ring])
        
        ring2 = (Item(theName: "Empty Ring", theSlot: .Feet, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .None), [.Ring])
        
        ammo = (Item(theName: "Empty Ammo", theSlot: .None, theSize: .Medium, aBonus: 0, sBonus: 0, naBonus: 0, dBonus: 0, maBonus: 0, theArmType: .LightArmor), [.Ammo])
        
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
        //rolls.sorted{$0 > $1}
        rolls.sort{$0 > $1}
        
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
        
        //Add in damage from any properties
        if weapon.properties != nil
        {
            for e in weapon.properties!
            {
                for damageQuantityDieTypes in e.damageQuantityDieTypes!
                {
                    if damageQuantityDieTypes.0 > 0 && damageQuantityDieTypes.1 != .None
                    {
                        dam += rollDie(damageQuantityDieTypes.0, die: damageQuantityDieTypes.1)
                    }
                }
            }
        }
        
        return (dam > 0 ? dam : 1)
    }
    
    func takeDamage(damage : Int)
    {
        currentHitPoints = currentHitPoints - damage
        
        //Create damage label above player
        displayFadeAwayLabel(String(-damage), color: (damage > 0 ? UIColor.redColor() : UIColor.darkGrayColor()))

        debugPrintln(name + " took \(damage) damage : \(currentHitPoints) hit points left")
        
        if(currentHitPoints <= 0)
        {
            unconscious = true
            
            if(currentHitPoints <= -10)
            {
                dead = true
            }
        }
    }
    
    func attackRange() -> Int
    {
        return rightHand.0.range
    }
    
    func rollInitiative() -> Int
    {
        return rollDie(1, die: .d20) + dexterityBonus
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
        //label.zPosition = 10
        
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
    
    //Complete this when I lay out the inventory slot view manually
    /*
    func equipItem(item : Item, toPlayerSlot : (Item, [Item.Slot]))
    {
        //If tried to equip to correct slot
        //if(contains(item.slot, toPlayerSlot.1))
        if(toPlayerSlot.1.contains(item.slot))
        {
            //If trying to equip two handed weapon
            if(item.slot == .TwoHanded)
            {
                //Unequip both hands and equip in clicked hand
                rightHand.0 = item
                leftHand.0 = item
            }
            else
            {
                //Equip in the slot
                toPlayerSlot.0 = item
            }
            
            return
        }
        
        debugPrintln("Could not equip")
    }
    */
    

    func equipItem(item : Item)
    {
        switch item.slot
            {
        case .OneHanded:
            
            //If holding a two handed weapon
            if rightHand.0.slot == Item.Slot.TwoHanded
            {
                //Unequip two handed weapon and equip new item in right hand
                leftHand.0 = Item.emptyItem()
                rightHand.0 = item
            }
                //If unarmed
            else if rightHand.0.slot == .None
            {
                //Equip in right hand
                rightHand.0 = item
            }
                //if holding one handed weapon in right hand
            else if rightHand.0.slot == .OneHanded
            {
                //Equip in left hand
                leftHand.0 = item
            }
                //holding one handed weapon in both hands
            else if rightHand.0.slot == .OneHanded && leftHand.0.slot == .OneHanded
            {
                //Equip in left hand
                leftHand.0 = item
            }
            
        case .TwoHanded:
            
            //Unequip weapons and equip two handed weapon in right hand
            leftHand.0 = Item.emptyItem()
            rightHand.0 = item
            
        case .Ammo:
            
            ammo.0 = item
            
        case .Body:
            
            body.0 = item
            
        case .Shoulders:
            
            shoulders.0 = item
            
        case .Head:
            
            head.0 = item
            
        case .Hands:
            
            hands.0 = item
            
        case .Wrists:
            
            wrists.0 = item
            
        case .Feet:
            
            feet.0 = item
            
        case .Eyes:
            
            eyes.0 = item
            
        case .Neck:
            
            neck.0 = item
            
        case .Torso:
            
            torso.0 = item
            
        case .Waist:
            
            waist.0 = item
            
        case .Ring:
            
            ring1.0 = item
            
            //Add in ring 2 stuff
            
        case .None:
            
            if leftHand.0.slot != .None
            {
                leftHand.0 = item
            }
            else
            {
                rightHand.0 = item
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
        var eItems : [Item] = [leftHand.0, rightHand.0, head.0, body.0, shoulders.0, hands.0, wrists.0, feet.0, waist.0, torso.0, eyes.0, ring1.0, ring2.0, neck.0, ammo.0]
        
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