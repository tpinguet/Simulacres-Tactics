//
//  PlayMenuLayer.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/3/13.
//  Copyright 2013 thierry. All rights reserved.
//

#import "PlayMenuLayer.h"
#import "cocos2d.h"
#import "CCBReader.h"
#import "CCControlButton.h"
#import "GameStatusManager.h"
#import "GameController.h"

@interface PlayMenuLayer() {
    CCControlButton *continueButton;
}
@end

@implementation PlayMenuLayer


-(void)buttonPressed:(id)sender {
    NSLog(@"continue button visibility is %d", continueButton.visible);
    CCControlButton *button = (CCControlButton*) sender;
    NSLog(@"%d", button.tag);
    GameStatusManager *gameStatusManager = [GameStatusManager gameStatusManager];
    NSLog(@"%@", gameStatusManager.testString);
    GameController *gm = [GameController sharedGameController];
    switch (button.tag) {
        case 1:
            //start new game
            [gm startNewGame];
            break;
        case 2:
            //continue existing game
            break;
        case 3:
            //return to previous menu
            //[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"]]];
            [[CCDirector sharedDirector] popScene];
            break;
            
        default:
            break;
    }
}

@end
