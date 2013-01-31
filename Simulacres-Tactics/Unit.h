//
//  Unit.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/30/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unit : NSObject

@property (assign) NSInteger strengthPoints;
@property (assign) NSInteger experience; //elite, average, poor
@property (assign) NSInteger type; //defines infantry, armor, etc...
@property (nonatomic, strong) NSString *name;

//initializing method
-(id)initWithStrengthPoints:(NSInteger)sp experience:(NSInteger)exp type:(NSInteger)t name:(NSString *)nameString;

//methods that tell us what this unit can do
-(BOOL)isInfantry;
-(BOOL)canDamageArmor;
-(BOOL)has360ArcOfFire;
-(BOOL)isMotorized;
-(BOOL)isArmored;
-(BOOL)isAntiAircraft;
-(BOOL)isArtillery;
-(BOOL)isOnBoard;
-(BOOL)isOffBoardArtillery;
-(BOOL)isOnBoardArtillery;
-(BOOL)canCarryInfantry;
-(BOOL)canMove;
-(BOOL)canMoveOnItsOwn;
-(BOOL)isCommander;

-(NSInteger)movementRange;

@end
