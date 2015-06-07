//
//  Property.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 12/6/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class Property
{
    var damageQuantityDieTypes : [(Int, Die, TypeEnum.DamageType)]?
    var spellLikeAbility : [(String, Int)]?  //Name, caster level
    
    init()
    {
        
    }
    
    //Should the property apply to the character or object being interacted with
    func shouldActivate() -> Bool   //-> Requirements
    {
        return true
    }
    
    /*
    var damageDie : Die
    var qntyOfDamageDice : Int
    var damageType : TypeEnum.EffectElement
    var statusChanges : [Status]?
    
    init(damDie : Die, dieQnty : Int, damType : TypeEnum.EffectElement, statusEffects : [Status]?)
    {
        damageDie = damDie
        qntyOfDamageDice = dieQnty
        damageType = damType
        
        if statusEffects != nil
        {
            statusChanges = statusEffects
        }
    }
    */
}