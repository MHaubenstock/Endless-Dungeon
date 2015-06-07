//
//  TypeEnums.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 10/21/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

class TypeEnum
{
    enum MonsterType
    {
        case Aberration
        case Animal
        case Humanoid
        case MagicalBeast
    }
    
    enum MosterSubtype
    {
        case Air
        case Angel
        case Aquatic
    }
    
    enum DamageType
    {
        case Normal
        case Air
        case Fire
        case Earth
        case Water
        case Poison
        case Sonic
    }
}