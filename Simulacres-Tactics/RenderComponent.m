//
//  RenderComponent.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "RenderComponent.h"

@implementation RenderComponent

- (id)initWithSprite:(CCSprite *)sprite {
    if ((self = [super init])) {
        self.sprite = sprite;
    }
    return self;
}

@end
