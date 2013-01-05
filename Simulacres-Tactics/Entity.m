//
//  Entity.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "Entity.h"
#import "EntityManager.h"

@implementation Entity {
    uint32_t _eid;
    EntityManager *_entityManager;
}

-(id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager {
    if ((self = [super init])) {
        _eid = eid;
        _entityManager = entityManager;
    }
    return self;
}

-(uint32_t)eid {
    return _eid;
}

-(RenderComponent *)render {
    return (RenderComponent *) [_entityManager getComponentOfClass:[RenderComponent class] forEntity:self];
}

@end
