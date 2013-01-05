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


@interface GameLayer() {
    CCSprite *gameBoard;
}

@end

@implementation GameLayer

-(void)buttonPressed:(id)sender {
   //return to main menu
   [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"]]];

}

-(void)didLoadFromCCB {
//    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"map_test.png"];
//    if (texture)
//    {
//        // Get the size of the new texture:
//        CGSize size = [texture contentSize];
//        
//        [gameBoard setTexture:texture];
//        // use the size of the new texture:
//        [gameBoard setTextureRect:CGRectMake(0.0f, 0.0f, size.width,size.height)];
//    }
//    
//    //experiment with entity/component/system
//    CharacterStat *stat = [[CharacterStat alloc] initWithBody:4 instinct:3 heart:2 mind:1 perception:10 action:10 desire:12 resistance:5 health:26 stamina:23 psychic:32 reign:@"Vegetal"];
//    StatComponent *statComponent = [[StatComponent alloc] initWithStat:stat];
//    EntityManager *entityManager = [[EntityManager alloc] init];
//    Entity *entity = [entityManager createEntity];
//    [entityManager addComponent:statComponent toEntity:entity];
    GameController *controller = [GameController gameController];
    controller._gameLayer = self;
}

#pragma mark - GestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    CCNode *node = aPanGestureRecognizer.node;
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
    
    node.position = ccpAdd(node.position, translation);
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)aPinchGestureRecognizer
{
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

@end
