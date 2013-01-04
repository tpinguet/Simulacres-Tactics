//
//  AboutMenuLayer.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/3/13.
//  Copyright 2013 thierry. All rights reserved.
//

#import "AboutMenuLayer.h"
#import "CCControlButton.h"
#import "CCBReader.h"


@implementation AboutMenuLayer

-(void)buttonPressed:(id)sender {
    CCControlButton *button = (CCControlButton*) sender;
    NSLog(@"%d", button.tag);
    switch (button.tag) {
        case 1:
            //return to previous menu
            //[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccbi"]]];
            [[CCDirector sharedDirector] popScene];
            break;
            
        default:
            break;
    }
}

@end
