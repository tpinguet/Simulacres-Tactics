//
//  GameController.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "GameController.h"
#import "CCBReader.h"
#import "RenderComponent.h" 

@implementation GameController

+(GameController *)gameController {
    static GameController *gC = nil;
    @synchronized(self) {
        if(!gC) {
            gC = [[GameController alloc] init];
            EntityManager *entityManager = [[EntityManager alloc] init];
            EntityFactory *entityFactory = [[EntityFactory alloc] initWithEntityManager:entityManager];
            gC._entityManager = entityManager;
            gC._entityFactory = entityFactory;
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

-(void)setGameLayer:(GameLayer *)gameLayer {
    [self._entityFactory setGameLayer:gameLayer];
}

-(void)startNewGame
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"]]];
    Entity *gameBoard = [self._entityFactory createGameBoard];
    RenderComponent *gameBoardRender = gameBoard.render;
    gameBoardRender.sprite.position = ccp(winSize.width/2, winSize.height/2);
}

@end
