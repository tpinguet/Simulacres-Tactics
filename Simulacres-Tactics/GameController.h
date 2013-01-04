//
//  GameController.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameController : NSObject

@property (nonatomic) BOOL gameInProgress;

+(GameController *)gameController;
-(void)startNewGame;

@end
