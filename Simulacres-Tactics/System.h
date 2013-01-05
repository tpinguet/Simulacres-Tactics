//
//  System.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EntityManager;
@class EntityFactory;

@interface System : NSObject

@property (strong) EntityManager *entityManager;
@property (strong) EntityFactory *entityFactory;

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory;
-(void)update:(float)dt;

@end
