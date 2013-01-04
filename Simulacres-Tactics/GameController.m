//
//  GameController.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "GameController.h"

@implementation GameController

+(GameController *)gameController {
    static GameController *gM = nil;
    @synchronized(self) {
        if(!gM) {
            gM = [[GameController alloc] init];
        }
    }
    return gM;
}

@end
