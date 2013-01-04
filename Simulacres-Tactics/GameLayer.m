//
//  GameLayer.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright 2013 thierry. All rights reserved.
//

#import "GameLayer.h"
#import "CCBReader.h"


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
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"map_test.png"];
    if (texture)
    {
        // Get the size of the new texture:
        CGSize size = [texture contentSize];
        
        [gameBoard setTexture:texture];
        // use the size of the new texture:
        [gameBoard setTextureRect:CGRectMake(0.0f, 0.0f, size.width,size.height)];
    }
}

@end
