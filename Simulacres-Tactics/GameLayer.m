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
#import "Unit.h"
#import "RenderComponent.h"
#import "UnitComponent.h"
#import "Entity.h"
#import "EntityManager.h"
#import "GameController.h"



@implementation GameLayer {
    //variables from CCBuilder Scene
    CCSprite *background;
    CCLabelTTF *coverLabel;
    CCLabelTTF *dieRollLabel;
    CCLabelTTF *resultLabel;
    CCLabelTTF *tileGIDLabel;
    CCLabelTTF *distanceLabel;
    BOOL drawLOS;
    NSMutableArray *linePoints;
    float totalTime;
    BOOL firstTap;
    CGPoint hex0;
    CGPoint hex1;
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
    firstTap = YES;
    [background setZOrder:-5];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"counters-test_UntitledSheet.plist"];
    //[self scheduleUpdate];
    [self setCover:0];
    [self setTileGID:10];
    [self setDieRoll:0];
    [self setResult:@"N/A"];
    linePoints = [NSMutableArray array];
    drawLOS = YES;
}

-(void)addMapRenderComponent:(CCTMXTiledMap *)map {
    hexMap = map;
    [self addChild:hexMap z:-1];
}

-(void)setLinePointsWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    [linePoints removeAllObjects];
    [linePoints addObject:NSStringFromCGPoint(pointA)];
    [linePoints addObject:NSStringFromCGPoint(pointB)];
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
    GameController *controller = [GameController sharedGameController];
    CCTMXLayer *layer = [hexMap layerNamed:@"terrain"];
    CGPoint location = [aTapGestureRecognizer locationInView:aTapGestureRecognizer.view];
    location.y = 768 - location.y;
    CGPoint hexTapped = [controller hexAtLocation:location] ;
    [self setTileGID:[controller tileGIDAtHex:hexTapped]];
    NSInteger cover = [controller coverAtHex:hexTapped];
    [self setCover:cover];
    [self setCover:[controller obstacleTileGIDAtGex:hexTapped]];
    NSInteger dieRoll = [controller roll1d6];
    [self setDieRoll:dieRoll];
    if( dieRoll-cover >= 5) {
        [self setResult:@"Hit"];
    } else {
        [self setResult:@"Miss"];
    }
    
    if( drawLOS == FALSE ) {
        if( firstTap == YES ) {
            [controller clearBoardStatus];
            CCSprite *tile = [layer tileAt:hexTapped];
            [tile setColor:ccc3(128, 128, 128)];
            hex0 = hexTapped;
            firstTap = FALSE;
            [controller highlightAllVisibleHexesFromHex:hexTapped];
            //[controller highlightAllHexesWithinDistance:4 fromHex:hexTapped];
            [tile setColor:ccc3(200,200,200)];
        } else {
            CCSprite *tile = [layer tileAt:hexTapped];
            [tile setColor:ccc3(128, 128, 128)];
            hex1 = hexTapped;
            NSMutableArray *tiles = [controller hexesInLineOfSightFromHex:hex0 toHex:hex1];
            for (id hexLocation in tiles ) {
                tile = [layer tileAt:[hexLocation CGPointValue]];
                [tile setColor:ccc3(128, 128, 128)];
            }
            [self setDistance:[controller distanceFromHex:hex0 toHex:hex1]];
            firstTap = YES;
            NSLog(@"line of sight %i",[controller lineOfSightFromHex:hex0 toHex:hex1]);
        }
    } else {
        if (firstTap == YES) {
            [controller clearBoardStatus];
            CCSprite *tile = [layer tileAt:hexTapped];
            [tile setColor:ccc3(128, 128, 128)];
            hex0 = hexTapped;
            firstTap = FALSE;
            [linePoints removeAllObjects];
        } else {
            CCSprite *tile = [layer tileAt:hexTapped];
            [tile setColor:ccc3(128, 128, 128)];
            hex1 = hexTapped;
            NSMutableArray *tiles = [controller hexesInLineOfSightFromHex:hex0 toHex:hex1];
            for (id hexLocation in tiles ) {
                tile = [layer tileAt:[hexLocation CGPointValue]];
                [tile setColor:ccc3(128, 128, 128)];
            }
            [self setDistance:[controller distanceFromHex:hex0 toHex:hex1]];
            [self setLinePointsWithPointA:[controller centerPointOnDisplayForHex:hex0] pointB:[controller centerPointOnDisplayForHex:hex1]];
            firstTap = YES;
        }
        
    }
    
}


- (void)handleUnitTapGestureRecognizer:(UITapGestureRecognizer*)aTapGestureRecognizer
{
    NSLog(@"Unit Tap gesture");
    GameController *controller = [GameController sharedGameController];
    CCNode *node = aTapGestureRecognizer.node;
    [node setPosition:[controller centerPointOnDisplayForHex:CGPointMake(6, 5)]];
    Entity *e = [controller unitTapped:node];
    if( e != nil ) {
        UnitComponent *unitComponent = (UnitComponent *)[controller.entityManager getComponentOfClass:[UnitComponent class] forEntity:e];
        NSLog(@"strength points: %i", unitComponent.unit.strengthPoints);
        
    }
}

-(void)setTileGID:(NSInteger)tileGID {
    tileGIDLabel.string = [NSString stringWithFormat:@"Tile GID: %i", tileGID];
}

-(void)setCover:(NSInteger)cover {
    coverLabel.string = [NSString stringWithFormat:@"Cover: %i", cover];
}

-(void)setDieRoll:(NSInteger)dieRoll {
    dieRollLabel.string = [NSString stringWithFormat:@"Die Roll: %i", dieRoll];
}

-(void)setDistance:(NSInteger)distance {
    distanceLabel.string = [NSString stringWithFormat:@"Distance: %i", distance];
}

-(void)setResult:(NSString *)resultString {
    resultLabel.string = resultString;
}

-(void)draw {
    [super draw];
    if ([linePoints count] > 0) {
        CGPoint start = CGPointFromString([linePoints objectAtIndex:0]);
        CGPoint end = CGPointFromString([linePoints objectAtIndex:1]);
        ccDrawLine(start, end);
    }
}

-(void)update:(ccTime)dt {
    totalTime += dt;
    //NSLog(@"%f", fmod(totalTime, 1.0));
    if( fmod(totalTime, 1.0) > 0.9 ) {
        GameController *controller = [GameController sharedGameController];
        //NSLog(@"Entity eid:%i", controller._eid);
        //[controller.entityFactory logAlive];
        //[controller._entityFactory numberOfEntities];
    }
}


@end
