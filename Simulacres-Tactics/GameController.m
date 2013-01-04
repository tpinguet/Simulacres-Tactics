//
//  GameController.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "GameController.h"
#import "CCBReader.h"

@implementation GameController

@synthesize gameInProgress;

+(GameController *)gameController {
    static GameController *gC = nil;
    @synchronized(self) {
        if(!gC) {
            gC = [[GameController alloc] init];
        }
    }
    return gC;
}

-(id)init {
    if((self = [super init])) {
        self.gameInProgress = FALSE;
    }
    return self;
}

-(void)startNewGame
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"]]];
}

@end
