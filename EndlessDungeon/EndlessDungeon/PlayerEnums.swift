//
//  PlayerEnums.swift
//  EndlessDungeon
//
//  Created by Michael Haubenstock on 9/26/14.
//  Copyright (c) 2014 Michael Haubenstock. All rights reserved.
//

import Foundation

enum Race
{
    case Human
    case Elf
    case Halfling
}

enum Alignment
{
    case LawfulEvil
    case Neutral
    case LawfulGood
}

enum Size
{
    case Diminutive
    case Tiny
    case Small
    case Medium
    case Large
    case Huge
    case Gargantuan
    case Colossal
}

enum Die
{
    case d2
    case d3
    case d4
    case d6
    case d8
    case d10
    case d12
    case d20
    case dPercent
    case None
}

enum Skill
{
    case Apparaise
    case Balance
    case Bluff
    case Climb
    case Concentration
    case Craft
    case DecipherScript
    case Diplomacy
    case DisableDevice
    case Disguise
    case EscapeArtist
    case Forgery
    case GatherInformation
    case HandleAnimal
    case Heal
    case Intimidate
    case Jump
    case KnowledgeArcane
    case KnowledgeDungeoneering
    case KnowledgeEngineering
    case KnowledgeLocal
    case knowledgeNobility
    case KnowledgeReligion
    case Listen
    case MoveSilently
    case OpenLock
    case Perform
    case Profession
    case Ride
    case Search
    case SenseMotive
    case SleightOfHand
    case SpeakLanguage
    case Spellcraft
    case Spot
    case Survival
    case Swim
    case Tumble
    case UseMagicDevice
    case UseRope
}