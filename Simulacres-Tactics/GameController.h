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

@interface GameController : NSObject

@property (nonatomic) BOOL gameInProgress;
@property (nonatomic, strong) EntityManager *_entityManager;
@property (nonatomic, strong) EntityFactory *_entityFactory;
@property (nonatomic, strong) GameLayer *_gameLayer;

+(GameController *)gameController;
-(void)startNewGame;

@end
