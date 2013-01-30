//
//  GameLayer.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer <UIGestureRecognizerDelegate> {
    CCTMXTiledMap *hexMap;
}

@property (strong) CCTMXTiledMap *hexMap;

-(void)addMapRenderComponent:(CCTMXTiledMap *)map;

//adjust displayed elements
-(void)setTileGID:(NSInteger)tileGID;
-(void)setCover:(NSInteger)cover;
-(void)setDieRoll:(NSInteger)dieRoll;
-(void)setDistance:(NSInteger)distance;
-(void)setResult:(NSString *)resultString;

@end
