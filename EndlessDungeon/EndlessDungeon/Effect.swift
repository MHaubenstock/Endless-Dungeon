//
//  Effects.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/20/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class Effect
{
    //Effects cause status change
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
}