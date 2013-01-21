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
-(BOOL)point:(CGPoint)location InsideHexAtCoord:(CGPoint)tileCoord;
-(void)displayLOS:(CGPoint)touchedTile;

@end
