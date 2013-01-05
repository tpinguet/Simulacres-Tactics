//
//  System.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "System.h"

@implementation System

- (id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if ((self = [super init])) {
        self.entityManager = entityManager;
        self.entityFactory = entityFactory;
    }
    return self;
}

- (void)update:(float)dt {
    
}

@end
