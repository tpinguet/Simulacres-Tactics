//
//  EntityManager.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "EntityManager.h"

@implementation EntityManager {
    NSMutableArray * _entities;
    NSMutableDictionary * _componentsByClass;
    uint32_t _lowestUnassignedEid;
}

- (id)init {
    if ((self = [super init])) {
        _entities = [NSMutableArray array];
        _componentsByClass = [NSMutableDictionary dictionary];
        _lowestUnassignedEid = 1;
    }
    return self;
}

- (uint32_t) generateNewEid {
    if (_lowestUnassignedEid < UINT32_MAX) {
        return _lowestUnassignedEid++;
    } else {
        for (uint32_t i = 1; i < UINT32_MAX; ++i) {
            if (![_entities containsObject:@(i)]) {
                return i;
            }
        }
        NSLog(@"ERROR: No available EIDs!");
        return 0;
    }
}

- (Entity *)createEntity {
    uint32_t eid = [self generateNewEid];
    [_entities addObject:@(eid)];
    return [[Entity alloc] initWithEid:eid entityManager:self];
}

- (void)addComponent:(Component *)component toEntity:(Entity *)entity {
    NSMutableDictionary * components = _componentsByClass[NSStringFromClass([component class])];
    if (!components) {
        components = [NSMutableDictionary dictionary];
        _componentsByClass[NSStringFromClass([component class])] = components;
    }
    components[@(entity.eid)] = component;
}

- (Component *)getComponentOfClass:(Class)class forEntity:(Entity *)entity {
    return _componentsByClass[NSStringFromClass(class)][@(entity.eid)];
}

- (void)removeEntity:(Entity *)entity {
    for (NSMutableDictionary * components in _componentsByClass.allValues) {
        if (components[@(entity.eid)]) {
            [components removeObjectForKey:@(entity.eid)];
        }
    }
    [_entities removeObject:@(entity.eid)];
}

-(void)removeEntityWithEid:(uint32_t)eid {
    [_entities removeObject:@(eid)];
}

- (NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class {
    NSMutableDictionary *components = _componentsByClass[NSStringFromClass(class)];
    if (components) {
        NSMutableArray * retval = [NSMutableArray arrayWithCapacity:components.allKeys.count];
        for (NSNumber * eid in components.allKeys) {
            [retval addObject:[[Entity alloc] initWithEid:eid.integerValue entityManager:self]];
        }
        return retval;
    } else {
        return [NSArray array];
    }
}

-(NSUInteger)numberOfEntities {
    return [_entities count];
}

-(NSUInteger)numberOfComponents { 
        NSMutableArray * retval = [NSMutableArray arrayWithCapacity:_componentsByClass.allKeys.count];
        for (NSNumber * eid in _componentsByClass.allKeys) {
            [retval addObject:[[Entity alloc] initWithEid:eid.integerValue entityManager:self]];
        }
    return [retval count];
}


@end
