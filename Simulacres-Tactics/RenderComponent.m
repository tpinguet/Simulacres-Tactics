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
        self.map = nil;
        self.isSprite = YES;
    }
    return self;
}

-(id)initWithMap:(CCTMXTiledMap *)tiledMap {
    if ((self = [super init])) {
        self.sprite = nil;
        self.map = tiledMap;
        self.isSprite = FALSE;
    }
    return self;
}

@end
