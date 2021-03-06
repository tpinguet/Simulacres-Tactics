//
//  EntityFactory.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entity;
@class EntityManager;
@class GameLayer;

@interface EntityFactory : NSObject

-(id)initWithEntityManager:(EntityManager *)entityManager;

-(Entity *)createGameBoard;
-(Entity *)createUnitInfantry;
-(void)logAlive;
-(void)numberOfEntities;

@end
