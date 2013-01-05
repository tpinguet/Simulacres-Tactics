//
//  CharacterStat.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "CharacterStat.h"

@implementation CharacterStat

-(id)initWithBody:(NSInteger)body instinct:(NSInteger)instinct heart:(NSInteger)heart mind:(NSInteger)mind perception:(NSInteger)perception action:(NSInteger)action desire:(NSInteger)desire resistance:(NSInteger)resistance health:(NSInteger)health stamina:(NSInteger)stamina psychic:(NSInteger)psychic reign:(NSString *)reign {
    if((self = [super init])) {
        self.body = body;
        self.instinct = instinct;
        self.heart = heart;
        self.mind = mind;
        self.perception = perception;
        self.action = action;
        self.desire = desire;
        self.resistance = resistance;
        self.health = health;
        self.stamina = stamina;
        self.psychic = psychic;
        self.reign = reign;
    }
    return self;
}

@end
