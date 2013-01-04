//
//  MainMenuLayer.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/3/13.
//  Copyright 2013 thierry. All rights reserved.
//

#import "MainMenuLayer.h"
#import "CCControlButton.h"
#import "CCBReader.h"


@implementation MainMenuLayer

-(void)buttonPressed:(id)sender {
    CCControlButton *button = (CCControlButton*) sender;
    NSLog(@"%d", button.tag);
    switch (button.tag) {
        case 3:
            //display the about menu
            [[CCDirector sharedDirector] pushScene:[CCBReader sceneWithNodeGraphFromFile:@"AboutMenu.ccbi"]];
            break;
        case 1:
            //display the play menu
            [[CCDirector sharedDirector] pushScene:[CCBReader sceneWithNodeGraphFromFile:@"PlayMenu.ccbi"]];
            break;
        case 2:
            //display the options menu
            break;
        default:
            break;
    }
}

@end
