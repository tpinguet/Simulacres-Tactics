//
//  EntityFactory.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "CCNode+SFGestureRecognizers.h"
#import "EntityFactory.h"
#import "EntityManager.h"
#import "GameLayer.h"
#import "cocos2d.h"
#import "RenderComponent.h"
#import "UnitComponent.h"
#import "BoardComponent.h"
#import "GameController.h"
#import "Unit.h"
#import "UnitDefinition.h"


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
    
    CCTMXTiledMap *tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"hexmap.tmx"];
    [tiledMap setIsTouchEnabled:YES];
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:[GameController sharedGameController].gameLayer action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = [GameController sharedGameController].gameLayer;
    [tiledMap addGestureRecognizer:panGestureRecognizer];
    UIGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:[GameController sharedGameController].gameLayer action:@selector(handlePinchGesture:)];
    pinchGestureRecognizer.delegate = [GameController sharedGameController].gameLayer;
    [tiledMap addGestureRecognizer:pinchGestureRecognizer];
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:[GameController sharedGameController].gameLayer action:@selector(handleRotationGestureRecognizer:)];
    rotationGestureRecognizer.delegate = [GameController sharedGameController].gameLayer;
    [tiledMap addGestureRecognizer:rotationGestureRecognizer];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[GameController sharedGameController].gameLayer action:@selector(handleTapGestureRecognizer:)];
    tapGestureRecognizer.delegate = [GameController sharedGameController].gameLayer;
    [tiledMap addGestureRecognizer:tapGestureRecognizer];
    
    
    Entity *entity = [_entityManager createEntity];
    [_entityManager addComponent:[[RenderComponent alloc] initWithMap:tiledMap] toEntity:entity];
    //[[GameController sharedGameController]._gameLayer setHexMap:tiledMap];
    //[[GameController sharedGameController]._gameLayer addChild:tiledMap];
    [_entityManager addComponent:[[BoardComponent alloc] initWithColumns:8 rows:8 ] toEntity:entity];
    return entity;
}

-(Entity *)createUnitInfantry {
    NSLog(@"creating infantry unit");
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"counter1"];
    [sprite setIsTouchEnabled:YES];
    [sprite setScale:1.5];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[GameController sharedGameController].gameLayer action:@selector(handleUnitTapGestureRecognizer:)];
    tapGestureRecognizer.delegate = [GameController sharedGameController].gameLayer;
    [sprite addGestureRecognizer:tapGestureRecognizer];
    
    Entity *entity = [_entityManager createEntity];
    [_entityManager addComponent:[[RenderComponent alloc] initWithSprite:sprite] toEntity:entity];
    Unit *infantryUnit = [[Unit alloc] initWithStrengthPoints:4 experience:unitExperienceAverage type:unitInfantry name:@"2nd Platoon"];
    NSLog(@"a");
    [_entityManager addComponent:[[UnitComponent alloc] initWithUnit:infantryUnit] toEntity:entity];
    return entity;
}

-(void)logAlive {
    NSLog(@"entity factory still alive");
}

-(void)numberOfEntities {
    NSLog(@"entity factory entity manager has %i entities", [_entityManager numberOfEntities]);
}

@end
