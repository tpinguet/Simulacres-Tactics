//
//  EntityFactory.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "EntityFactory.h"
#import "EntityManager.h"
#import "GameLayer.h"
#import "cocos2d.h"
#import "RenderComponent.h"
#import "StatComponent.h"
#import "BoardComponent.h"
#import "GameController.h"

@implementation EntityFactory {
    EntityManager *_entityManager;
}

-(id)initWithEntityManager:(EntityManager *)entityManager  {
    if ((self = [super init])) {
        _entityManager = entityManager;
    }
    return self;
}

-(Entity *)createGameBoard {
    CCSprite *gameBoardSprite = [[CCSprite alloc] initWithFile:@"map_test.png"];
    Entity *entity = [_entityManager createEntity];
    [_entityManager addComponent:[[RenderComponent alloc] initWithSprite:gameBoardSprite] toEntity:entity];
    [[GameController gameController]._gameLayer addChild:gameBoardSprite];
    [_entityManager addComponent:[[BoardComponent alloc] initWithColumns:10 rows:5 ] toEntity:entity];
    return entity;
}

@end
