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

@synthesize entityManager, entityFactory, gameLayer;
@synthesize gameInProgress, eid;

+(GameController *)sharedGameController {
    static GameController *sharedGameController = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{ sharedGameController = [[GameController alloc] init]; });
    return sharedGameController;
}


-(id)init {
    if((self = [super init])) {
        self.entityManager = [[EntityManager alloc] init];
        self.entityFactory = [[EntityFactory alloc] initWithEntityManager:self.entityManager];
    }
    return self;
}

-(void)startNewGame
{
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"]]];
    Entity *gameBoard = [self.entityFactory createGameBoard];
    //Entity *character = [self._entityFactory createSimpleEntity];
    //NSLog(@"Entity eid:%i", gameBoard.eid);
    self.eid = gameBoard.eid;
    [self numberOfEntities];
    //NSLog(@"length of _entities:%i", [_entityManager numberOfEntities]);
    RenderComponent *gameBoardRender = gameBoard.render;
    gameBoardRender.map.scale = 1.0;
    gameBoardRender.map.position = ccp(0,0);
    [self.gameLayer addMapRenderComponent:gameBoardRender.map];
}

-(void)numberOfEntities {
    NSLog(@"length of _entities:%i", [self.entityManager numberOfEntities]);
    NSLog(@"length of _components:%i", [self.entityManager numberOfComponents]);
}

-(void)closeGame
{
    NSLog(@"closeGame");

}

@end
