//
//  GameStatusManager.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "GameStatusManager.h"

@implementation GameStatusManager

@synthesize testString;

+(GameStatusManager *)gameStatusManager {
    static GameStatusManager *gSM = nil;
    @synchronized(self) {
        if(!gSM) {
            gSM = [[GameStatusManager alloc] init];
        }
    }
    return gSM;
}

-(id)init {
    if((self = [super init])) {
        self.testString = @"test";
    }
    return self;
}

@end
