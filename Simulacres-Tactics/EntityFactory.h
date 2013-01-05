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

-(void)setGameLayer:(GameLayer *)gameLayer;

-(Entity *)createGameBoard;

@end
