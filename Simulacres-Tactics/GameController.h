//
//  GameController.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "EntityManager.h"
#import "EntityFactory.h"
#import "cocos2d.h"
#import "GameLayer.h"

@interface GameController : NSObject

@property (assign) BOOL gameInProgress;
@property (strong) EntityManager *entityManager;
@property (strong) EntityFactory *entityFactory;
@property (strong) GameLayer *gameLayer;
@property (assign) uint32_t eid;

+(GameController *)sharedGameController;
-(void)startNewGame;
-(void)numberOfEntities;
-(void)closeGame;

@end
