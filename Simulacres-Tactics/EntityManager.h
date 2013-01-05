//
//  EntityManager.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"
#import "Entity.h"

@interface EntityManager : NSObject

- (uint32_t) generateNewEid;
- (Entity *)createEntity;
- (void)addComponent:(Component *)component toEntity:(Entity *)entity;
- (Component *)getComponentOfClass:(Class)class forEntity:(Entity *)entity;
- (void)removeEntity:(Entity *)entity;
- (NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class;

@end
