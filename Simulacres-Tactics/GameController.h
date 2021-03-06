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

+(GameController *)sharedGameController;
-(void)startNewGame;
-(void)numberOfEntities;
-(void)closeGame;

//methods for dealing with hexes and board in general
-(CGPoint)centerPointOnDisplayForHex:(CGPoint)hex;
-(CGPoint)hexAtLocation:(CGPoint)location;
-(BOOL)point:(CGPoint)location InsideHex:(CGPoint)hex;
-(NSMutableArray *)hexesInLineOfSightFromHex:(CGPoint)hex0 toHex:(CGPoint)hex1;
-(NSInteger)distanceFromHex:(CGPoint)hex0 toHex:(CGPoint)hex1;
-(BOOL)lineOfSightFromHex:(CGPoint)hex0 toHex:(CGPoint)hex1;
-(NSInteger)tileGIDAtHex:(CGPoint)hex;
-(NSInteger)obstacleTileGIDAtGex:(CGPoint)hex;
-(NSInteger)coverAtHex:(CGPoint)hex;
-(NSInteger)heightAtHex:(CGPoint)hex;
-(void)highlightAllVisibleHexesFromHex:(CGPoint)hex;
-(void)highlightAllHexesWithinDistance:(NSInteger)distance fromHex:(CGPoint)hex;
-(void)clearBoardStatus;

//methods for dealing with Units
-(Entity *)unitTapped:(CCNode *)node;

//game mechanics methods
-(NSInteger)roll1d6;

@end
