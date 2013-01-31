//
//  UnitComponent.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/30/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "UnitComponent.h"
#import "UnitDefinition.h"

@implementation UnitComponent

@synthesize unit;

-(id)initWithUnit:(Unit *)u {
    if((self = [super init])) {
        unit = u;
    }
    return self;
}

@end
