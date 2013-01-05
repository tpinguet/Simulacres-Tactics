//
//  Entity.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderComponent.h"

@class EntityManager;

@interface Entity : NSObject

- (id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager;
- (uint32_t)eid;

-(RenderComponent *)render;

@end
