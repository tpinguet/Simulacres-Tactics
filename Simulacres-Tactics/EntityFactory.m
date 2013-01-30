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
#import "StatComponent.h"
#import "BoardComponent.h"
#import "GameController.h"
#import "CharacterStat.h"

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

-(Entity *)createCounter1 {
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"counter1"];
    [sprite setIsTouchEnabled:YES];
        
    Entity *entity = [_entityManager createEntity];
    [_entityManager addComponent:[[RenderComponent alloc] initWithSprite:sprite] toEntity:entity];
     return entity;
}


-(Entity *)createCounter2 {
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"counter2"];
    [sprite setIsTouchEnabled:YES];
    
    Entity *entity = [_entityManager createEntity];
    [_entityManager addComponent:[[RenderComponent alloc] initWithSprite:sprite] toEntity:entity];
    return entity;
}

-(Entity *)createSimpleEntity {
    CharacterStat *stat = [[CharacterStat alloc] initWithBody:2 instinct:3 heart:3 mind:3 perception:2 action:2 desire:2 resistance:2 health:2 stamina:2 psychic:2 reign:@"a"];
    Entity *entity = [_entityManager createEntity];
    StatComponent *statComponent = [[StatComponent alloc] initWithStat:stat];
    [_entityManager addComponent:statComponent toEntity:entity];
    return entity;
}

-(void)logAlive {
    NSLog(@"entity factory still alive");
}

-(void)numberOfEntities {
    NSLog(@"entity factory entity manager has %i entities", [_entityManager numberOfEntities]);
}

@end
