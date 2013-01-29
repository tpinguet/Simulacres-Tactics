//
//  GameController.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "GameController.h"
#import "CCBReader.h"
#import "RenderComponent.h" 




@implementation GameController 

@synthesize entityManager, entityFactory, gameLayer;
@synthesize gameInProgress;


#pragma initialization of new singleton
+(GameController *)sharedGameController {
    static GameController *sharedGameController = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{ sharedGameController = [[GameController alloc] init]; });
    return sharedGameController;
}


-(id)init {
    if((self = [super init])) {
        self.entityManager = [[EntityManager alloc] init];
        self.entityFactory = [[EntityFactory alloc] initWithEntityManager:self.entityManager];
    }
    return self;
}


#pragma starting/stopping game
-(void)startNewGame
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //Load the Game scene
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"]]];
    
    //Create the entities
    Entity *gameBoard = [self.entityFactory createGameBoard];
    Entity *counter1 = [self.entityFactory createCounter1];
    Entity *counter2 = [self.entityFactory createCounter1];

    //Place entities on the game scene
    //game board
    RenderComponent *gameBoardRender = gameBoard.render;
    gameBoardRender.map.scale = 1.0;
    gameBoardRender.map.position = ccp(0,0);
    [self.gameLayer addMapRenderComponent:gameBoardRender.map];
    
    //Entity counter1
    //RenderComponent *counter1Render = counter1.render;
    //counter1Render.sprite.position = ccp( winSize.width/2, winSize.height/2 );
    //[self.gameLayer addChild:counter1Render.sprite];
}

-(void)numberOfEntities {
    NSLog(@"length of _entities:%i", [self.entityManager numberOfEntities]);
    NSLog(@"length of _components:%i", [self.entityManager numberOfComponents]);
}

-(void)closeGame
{
    NSLog(@"closeGame");

}


#pragma hex tiled map methos
-(CGPoint)hexAtLocation:(CGPoint)location {
    
    CCTMXTiledMap *hexMap = gameLayer.hexMap;
    CGSize mapSize = hexMap.mapSize;
    CGSize hexSize = hexMap.tileSize;
    float scale = hexMap.scale;
    float circleRadius = hexSize.width * 0.5 * 0.75 * scale;
    CCTMXLayer *layer = [hexMap layerNamed:@"terrain"];
    
    for (int x = 0; x < mapSize.width; x++) {
        for (int y = 0; y < mapSize.height; y++) {
            if( [self point:location InsideHex:CGPointMake(x, y)] ) {
                return CGPointMake(x, y);
            }
        }
    }
    return CGPointMake(-1, -1);
}

-(BOOL)point:(CGPoint)location InsideHex:(CGPoint)hex {
    //first determine center of hex
    int x = hex.x;
    int y = hex.y;
    
    BOOL isOddColumn = NO;
    if (x % 2 == 0) {
        isOddColumn = NO;
    } else {
        isOddColumn = YES;
    }
    
    CCTMXTiledMap *hexMap = gameLayer.hexMap;
    CGSize mapSize = hexMap.mapSize;
    CGSize hexSize = hexMap.tileSize;
    CGFloat scale = hexMap.scale;
    CGFloat radius = hexSize.width/2;
    CGFloat s = 0.75*hexSize.width;
    CGPoint mapPixelPosition = hexMap.position;
    
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

-(NSInteger)distanceFromHex:(CGPoint)hex0 toHex:(CGPoint)hex1 {
    return [[self hexesInLineOfSightFromHex:hex0 toHex:hex1] count]-1;
}


-(NSMutableArray *)hexesInLineOfSightFromHex:(CGPoint)hex0 toHex:(CGPoint)hex1 {
    CCTMXTiledMap *hexMap = gameLayer.hexMap;
    CGSize mapSize = hexMap.mapSize;
    CGSize hexSize = hexMap.tileSize;
    CGFloat scale = hexMap.scale;
    CGFloat radius = hexSize.width/2;
    CGFloat s = 0.75*hexSize.width;
    CGPoint mapPixelPosition = hexMap.position;
    CCTMXLayer *layer = [hexMap layerNamed:@"terrain"];

    NSMutableArray *tilesOnLOS = [[NSMutableArray alloc] init];
    [tilesOnLOS removeAllObjects];
    
    int x0 = hex0.x;
    int y0 = hex0.y;
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

    int x1 = hex1.x;
    int y1 = hex1.y;
    
    if( x1 == x0 && y1 == y0 ) {
        //do nothing
        return [NSArray array];
    } else {
        //translate into cartesian coordinates from hex grid coordinates
        isOddColumn = NO;
        if (x1 % 2 == 0) {
            isOddColumn = NO;
        } else {
            isOddColumn = YES;
        }
        float YPos1 = hexSize.height*((mapSize.height-1-y1)+0.5)*scale+mapPixelPosition.y;
        if (isOddColumn) {
            YPos1 -= hexSize.height * 0.5 * scale;
        }
        float XPos1 = (s*x1+hexSize.width*0.5)*scale+mapPixelPosition.x;

            
        //we're going to test 100 points along the line
        float nmax = 100;
        
        for (int n = 0; n <= nmax; n++) {
            float Xn = XPos0 + n * (XPos1-XPos0) / nmax;
            float Yn = YPos0 + n * (YPos1-YPos0) / nmax;
            //find which hex this point is in
            CGPoint currentHex = [self hexAtLocation:CGPointMake(Xn, Yn)];
            //add to list if not already previously traversed
            if (CGPointEqualToPoint( currentHex, CGPointMake(-1, -1)) == FALSE) {
                if ([tilesOnLOS count] > 0) {
                    NSValue *val = [tilesOnLOS lastObject];
                    CGPoint p = [val CGPointValue];
                    if ( CGPointEqualToPoint(p, currentHex) == FALSE ) {
                        //NSLog(@"(%f,%f)\n", currentHex.x, currentHex.y);
                        [tilesOnLOS addObject:[NSValue valueWithCGPoint:currentHex]];
                    }
                } else {
                    [tilesOnLOS addObject:[NSValue valueWithCGPoint:currentHex]];
                }
            }
        }
    }
    return tilesOnLOS;
}

-(BOOL)lineOfSightFromHex:(CGPoint)hex0 toHex:(CGPoint)hex1 {
    return YES;
}

-(NSInteger)tileGIDAtHex:(CGPoint)hex {
    CCTMXTiledMap *hexMap = gameLayer.hexMap;
    CCTMXLayer *layer = [hexMap layerNamed:@"terrain"];
    return [layer tileGIDAt:hex];
}

-(NSInteger)coverAtHex:(CGPoint)hex {
    NSInteger tileGID = [self tileGIDAtHex:hex];
    switch (tileGID) {
        case 2:
            return 1;
            break;
        case 5:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(void)clearBoardStatus {
    CCTMXTiledMap *hexMap = gameLayer.hexMap;
    CGSize mapSize = hexMap.mapSize;
    CGSize hexSize = hexMap.tileSize;
    CGFloat scale = hexMap.scale;
    CGFloat radius = hexSize.width/2;
    CGFloat s = 0.75*hexSize.width;
    CGPoint mapPixelPosition = hexMap.position;
    CCTMXLayer *layer = [hexMap layerNamed:@"terrain"];
    
    for (int i = 0; i < mapSize.width; i++) {
        for (int j = 0; j < mapSize.height; j++) {
            CCSprite *tile = [layer tileAt:CGPointMake(i, j)];
            [tile setColor:ccc3(255, 255, 255)];
        }
    }
}


#pragma Game mechanics
-(NSInteger)roll1d6 {
    return 1+arc4random()%6;
}

@end
