//
//  RenderComponent.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"

@interface RenderComponent : Component

@property (strong) CCSprite *sprite;
@property (strong) CCTMXTiledMap *map;
@property (assign) BOOL isSprite;

-(id)initWithSprite:(CCSprite *)sprite;
-(id)initWithMap:(CCTMXTiledMap *)tiledMap;

@end
