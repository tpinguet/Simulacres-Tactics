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
    //variables from CCBuilder Scene
    CCSprite *background;
    CCLabelTTF *coverLabel;
    CCLabelTTF *dieRollLabel;
    CCLabelTTF *resultLabel;
    CCLabelTTF *tileGIDLabel;
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
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"counters-test_UntitledSheet.plist"];
    //[self scheduleUpdate];
    [self setCover:0];
    [self setTileGID:10];
    [self setDieRoll:0];
    [self setResult:@"N/A"];
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
    GameController *controller = [GameController sharedGameController];
    CCTMXLayer *layer = [hexMap layerNamed:@"terrain"];
    CGPoint location = [aTapGestureRecognizer locationInView:aTapGestureRecognizer.view];
    location.y = 768 - location.y;
    
    CGPoint hexTapped = [controller hexAtLocation:location] ;
    [self setTileGID:[controller tileGIDAtHex:hexTapped]];
    NSInteger cover = [controller coverAtHex:hexTapped];
    [self setCover:cover];
    NSInteger dieRoll = [controller roll1d6];
    [self setDieRoll:dieRoll];
    if( dieRoll-cover >= 5) {
        [self setResult:@"Hit"];
    } else {
        [self setResult:@"Miss"];
    }
    
    NSLog(@"Tile tapped is (%f, %f)", hexTapped.x, hexTapped.y);
    if( firstTap == YES ) {
        [controller clearBoardStatus];
        CCSprite *tile = [layer tileAt:hexTapped];
        [tile setColor:ccc3(128, 128, 128)];
        hex0 = hexTapped;
        firstTap = FALSE;
    } else {
        CCSprite *tile = [layer tileAt:hexTapped];
        [tile setColor:ccc3(128, 128, 128)];
        hex1 = hexTapped;
        NSMutableArray *tiles = [controller hexesInLineOfSightFromHex:hex0 toHex:hex1];
        for (id hexLocation in tiles ) {
            CGPoint temp = [hexLocation CGPointValue];
            NSLog(@"tile at location: (%f, %f)\n",  temp.x, temp.y);
            tile = [layer tileAt:[hexLocation CGPointValue]];
            [tile setColor:ccc3(128, 128, 128)];
        }
        NSLog(@"Distance between the two tiles is: %i\n", [controller distanceFromHex:hex0 toHex:hex1]);
        firstTap = YES;
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

-(void)setResult:(NSString *)resultString {
    resultLabel.string = resultString;
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


@end
