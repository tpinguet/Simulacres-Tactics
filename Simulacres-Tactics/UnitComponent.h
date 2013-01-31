//
//  UnitComponent.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/30/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "Component.h"
#import "Unit.h"

@interface UnitComponent : Component

@property (nonatomic, strong) Unit *unit;

-(id)initWithUnit:(Unit *)u;

@end
