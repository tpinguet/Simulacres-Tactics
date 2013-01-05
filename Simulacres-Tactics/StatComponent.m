//
//  StatComponent.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "StatComponent.h"

@implementation StatComponent

-(id)initWithStat:(CharacterStat *)stat {
    if((self = [super init])) {
        self.stat = stat;
    }
    return self;
}

@end
