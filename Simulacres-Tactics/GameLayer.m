//
//  GameLayer.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright 2013 thierry. All rights reserved.
//

#import "GameLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "CCBReader.h"
#import "CharacterStat.h"
#import "RenderComponent.h"
#import "StatComponent.h"
#import "Entity.h"
#import "EntityManager.h"
#import "GameController.h"



@implementation GameLayer {
    float totalTime;
    NSMutableArray *linePoints;
    CCSprite *background;
}

@synthesize hexMap;

-(void)buttonPressed:(id)sender {
    //return to main menu
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"]]];
    [[GameController sharedGameController] closeGame];
}

-(void)didLoadFromCCB {
    GameController *controller = [GameController sharedGameController];
    controller.gameLayer = self;
    totalTime = 0;
    linePoints = [NSMutableArray array];
    //[self scheduleUpdate];
}

-(void)addMapRenderComponent:(CCTMXTiledMap *)map {
    self.hexMap = map;
    [self addChild:self.hexMap z:-1];
    [background setZOrder:-5];
}

#pragma mark - GestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    NSLog(@"pan gesture");
    CCNode *node = aPanGestureRecognizer.node;
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
    
    node.position = ccpAdd(node.position, translation);
    //NSLog(@"%f, %f\n", node.position.x, node.position.y);
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)aPinchGestureRecognizer
{
    NSLog(@"pinch gesture");
    if (aPinchGestureRecognizer.state == UIGestureRecognizerStateBegan || aPinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CCNode *node = aPinchGestureRecognizer.node;
        float scale = [aPinchGestureRecognizer scale];
        node.scale *= scale;
        aPinchGestureRecognizer.scale = 1;
    }
}

- (void)handleRotationGestureRecognizer:(UIRotationGestureRecognizer*)aRotationGestureRecognizer
{
    if (aRotationGestureRecognizer.state == UIGestureRecognizerStateBegan || aRotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CCNode *node = aRotationGestureRecognizer.node;
        float rotation = aRotationGestureRecognizer.rotation;
        node.rotation += CC_RADIANS_TO_DEGREES(rotation);
        aRotationGestureRecognizer.rotation = 0;
    }
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer*)aTapGestureRecognizer
{
    NSLog(@"Tap gesture");
    CGPoint location = [aTapGestureRecognizer locationInView:aTapGestureRecognizer.view];
    location.y = 768 - location.y;
    CCLOG(@"%f, %f\n", location.x, location.y);
    CGSize mapSize = self.hexMap.mapSize;
    CGSize hexSize = self.hexMap.tileSize;
    float scale = self.hexMap.scale;
    //float dX = sqrt( (hexSize.height * hexSize.height) * 0.75 );
    float circleRadius = hexSize.width * 0.5 * 0.75 * scale;
    CCTMXLayer *layer = [self.hexMap layerNamed:@"Layer 0"];
    
    //first reset all tiles to baseline opacity
    for (int x = 0; x < mapSize.width; x++) {
        for (int y = 0; y < mapSize.height; y++) {
            CGPoint touchedTile = CGPointMake(x,y);
            CCSprite *tile = [layer tileAt:touchedTile];
            [tile setOpacity:255];
        }
    }
    
    //NSLog(@"%f, %f", mapSize.width, mapSize.height);
    //NSLog(@"%f, %f", hexSize.width, hexSize.height);
    //NSLog(@"scale: %f", scale);
    
    for (int x = 0; x < mapSize.width; x++) {
        for (int y = 0; y < mapSize.height; y++) {
            // get the pixel position of the hex
            //CGPoint hexPosition = [self tilePixelCoord:CGPointMake(x, y)];
            
            // if the distance from the center of the hex to the touch location
            // is less than the circle radius then the hex is being touched
//            if (ccpLengthSQ(ccpSub(location, hexPosition)) < (circleRadius * circleRadius) ) {
//                CCLOG(@"You touched (%i, %i)",x,y);
//                CGPoint touchedTiled = CGPointMake(x,y);
//                //[layer setTileGID:1 at:touchedTiled];
//                CCSprite *tile = [layer tileAt:touchedTiled];
//                if(tile.opacity == 128) {
//                    [tile setOpacity:255];
//                } else {
//                    [tile setOpacity:128];
//                }
//                //return CGPointMake(x, y);
//                return;
//            }
            
            if( [self point:location InsideHexAtCoord:CGPointMake(x, y)] ) {
                CGPoint touchedTile = CGPointMake(x,y);
                CCSprite *tile = [layer tileAt:touchedTile];
                [self displayLOS:touchedTile];
                return;
            }
        }
    }
}

-(CGPoint)tilePixelCoord:(CGPoint)tileCoord {
    int x = tileCoord.x;
    int y = tileCoord.y;
    
    BOOL isOddColumn = NO;
    if (x % 2 == 0) {
        isOddColumn = NO;
    } else {
        isOddColumn = YES;
    }

    CGSize mapSize = self.hexMap.mapSize;
    CGSize hexSize = self.hexMap.tileSize;
    CGFloat scale = self.hexMap.scale;
    //CGFloat radius = hexSize.height/sqrt(3);
    CGFloat s = 0.75*hexSize.width;
    CGPoint mapPixelPosition = self.hexMap.position;

    float YPos = hexSize.height*((mapSize.height-1-y)+0.5)*scale+mapPixelPosition.y;
    if (isOddColumn) {
        YPos -= hexSize.height * 0.5 * scale;
    }
    
    float XPos = (s*x+hexSize.width*0.5)*scale+mapPixelPosition.x;
    return CGPointMake(XPos, YPos);
}

-(BOOL)point:(CGPoint)location InsideHexAtCoord:(CGPoint)tileCoord {
    //first determine center of hex
    int x = tileCoord.x;
    int y = tileCoord.y;
    
    BOOL isOddColumn = NO;
    if (x % 2 == 0) {
        isOddColumn = NO;
    } else {
        isOddColumn = YES;
    }
    
    CGSize mapSize = self.hexMap.mapSize;
    CGSize hexSize = self.hexMap.tileSize;
    CGFloat scale = self.hexMap.scale;
    CGFloat radius = hexSize.width/2;
    CGFloat s = 0.75*hexSize.width;
    CGPoint mapPixelPosition = self.hexMap.position;
    
    float YPos = hexSize.height*((mapSize.height-1-y)+0.5)*scale+mapPixelPosition.y;
    if (isOddColumn) {
        YPos -= hexSize.height * 0.5 * scale;
    }
    float XPos = (s*x+hexSize.width*0.5)*scale+mapPixelPosition.x;
    
    //then quickly check if point is outside of circle enclosing hex
    if( ccpLengthSQ(ccpSub(location, CGPointMake(XPos, YPos))) > (radius*scale)*(radius*scale) ) {
        return FALSE;
    }
    
    //then test angle to all normal to edges
    for (int i = 0; i < 5; i++) {
        float xA = XPos + radius*scale*cos(M_PI/2-(i+0.5)*M_PI/3);
        float yA = YPos + radius*scale*sin(M_PI/2-(i+0.5)*M_PI/3);
        float xB = XPos + radius*scale*cos(M_PI/2-(i+1.5)*M_PI/3);
        float yB = YPos + radius*scale*sin(M_PI/2-(i+1.5)*M_PI/3);
        float xC = (xA+xB)/2;
        float yC = (yA+yB)/2;
        float normalVectorX = (yB-yA);
        float normalVectorY = -(xB-xA);
        float testVectorX = (location.x-xC);
        float testVectorY = (location.y-yC);
        if( normalVectorX*testVectorX + normalVectorY*testVectorY < 0 ) {
            return FALSE;
        }
    }
    return YES;
}

-(void)displayLOS:(CGPoint)touchedTile {
    //algorithm is basically to cycle through each tile and determine if LOS exists by tracing a line to it and looking for obstructions in between
    
    int x0 = touchedTile.x;
    int y0 = touchedTile.y;
    
    CGSize mapSize = self.hexMap.mapSize;
    CGSize hexSize = self.hexMap.tileSize;
    CGFloat scale = self.hexMap.scale;
    CGFloat radius = hexSize.width/2;
    CGFloat s = 0.75*hexSize.width;
    CGPoint mapPixelPosition = self.hexMap.position;
    CCTMXLayer *layer = [self.hexMap layerNamed:@"Layer 0"];
    
    CCSprite *tile = [layer tileAt:touchedTile];
    [tile setOpacity:200];
    int tileGID = [layer tileGIDAt:touchedTile];
    
    
    
    
    NSMutableArray *tilesOnLOS = [[NSMutableArray alloc] init];
    
    BOOL isOddColumn = NO;
    if (x0 % 2 == 0) {
        isOddColumn = NO;
    } else {
        isOddColumn = YES;
    }

    
    float YPos0 = hexSize.height*((mapSize.height-1-y0)+0.5)*scale+mapPixelPosition.y;
    if (isOddColumn) {
        YPos0 -= hexSize.height * 0.5 * scale;
    }
    float XPos0 = (s*x0+hexSize.width*0.5)*scale+mapPixelPosition.x;

    
    
    CGPoint hexToTest = CGPointMake(x0, y0);
    BOOL notVisible;
    NSLog(@"Starting from tile (%i,%i) at coordinates (%f,%f)", x0, y0, XPos0, YPos0);
    
    //for (int x = 0; x < mapSize.width; x++) {
        int x = 0 ;
        int y = 0 ;
        //for (int y = 0; y < mapSize.height; y++) {
            [tilesOnLOS removeAllObjects];
            NSLog(@"count: %i", [tilesOnLOS count]);
            if( x == x0 && y == y0 ) {
                //do nothing
            } else {
                //translate into cartesian coordinates from hex grid coordinates
                isOddColumn = NO;
                if (x % 2 == 0) {
                    isOddColumn = NO;
                } else {
                    isOddColumn = YES;
                }
                float YPos = hexSize.height*((mapSize.height-1-y)+0.5)*scale+mapPixelPosition.y;
                if (isOddColumn) {
                        YPos -= hexSize.height * 0.5 * scale;
                }
                float XPos = (s*x+hexSize.width*0.5)*scale+mapPixelPosition.x;
                [linePoints removeAllObjects];
                [linePoints addObject:NSStringFromCGPoint(CGPointMake(XPos0, YPos0))];
                [linePoints addObject:NSStringFromCGPoint(CGPointMake(XPos, YPos))];
                
                
                //we're going to test 100 points along the line
                float nmax = 100;
                hexToTest = CGPointMake(x0, y0);
                
                NSLog(@"Testing tile (%i, %i) with coordinates (%f, %f)", x, y, XPos, YPos);
                
                notVisible = FALSE;
                
                for (int n = 0; n <= nmax; n++) {
                    float Xn = XPos0 + n * (XPos-XPos0) / nmax;
                    float Yn = YPos0 + n * (YPos-YPos0) / nmax;
                    //find which hex this point is in
                    for (int i = 0; i < mapSize.width; i++) {
                        for (int j = 0; j < mapSize.height; j++) {
                            if( [self point:CGPointMake(Xn, Yn) InsideHexAtCoord:CGPointMake(i, j)]) {
                                hexToTest = CGPointMake(i, j);
                                //NSLog(@"tile crossed: (%f, %f)", hexToTest.x, hexToTest.y);
                                if ([tilesOnLOS count] > 0) {
                                    NSValue *val = [tilesOnLOS lastObject];
                                    CGPoint p = [val CGPointValue];
                                    if ( CGPointEqualToPoint(p, hexToTest) == FALSE ) {
                                        //NSLog(@"tile (%f, %f)", hexToTest.x, hexToTest.y);
                                        [tilesOnLOS addObject:[NSValue valueWithCGPoint:hexToTest]];
                                    }
                                } else {
                                    //NSLog(@"tile (%f, %f)", hexToTest.x, hexToTest.y);
                                    [tilesOnLOS addObject:[NSValue valueWithCGPoint:hexToTest]];
                                }
                            }
                        }
                    }
                }
                //enumerate over tiles found and remove duplicates
                for(id val in tilesOnLOS) {
                    CGPoint tilePoint = [val CGPointValue];
                    NSLog(@"tile (%f, %f)", tilePoint.x, tilePoint.y);
                    CCSprite *tile = [layer tileAt:tilePoint];
                    [tile setOpacity:200];
                }
            }
        //}
   //}
}

-(void)update:(ccTime)dt {
    totalTime += dt;
    //NSLog(@"%f", fmod(totalTime, 1.0));
    if( fmod(totalTime, 1.0) > 0.9 ) {
        GameController *controller = [GameController sharedGameController];
        //NSLog(@"Entity eid:%i", controller._eid);
        [controller.entityFactory logAlive];
        //[controller._entityFactory numberOfEntities];
        [controller.entityFactory createSimpleEntity];
    }
}

-(void)draw {
    
    if([linePoints count] > 0) {
        //NSLog(@"%i", [linePoints count]);
        CGPoint start = CGPointFromString([linePoints objectAtIndex:0]);
        CGPoint end = CGPointFromString([linePoints objectAtIndex:1]);
        //NSLog(@"(%f,%f) to (%f,%f)", start.x, start.y, end.x, end.y);
        ccDrawLine(start, end);
    }
    [super draw];
    
}

@end
