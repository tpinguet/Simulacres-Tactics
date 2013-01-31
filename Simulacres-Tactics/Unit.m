//
//  Unit.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/30/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "Unit.h"
#import "UnitDefinition.h"

@implementation Unit

@synthesize name;
@synthesize strengthPoints, experience, type;

#pragma initialization
-(id)initWithStrengthPoints:(NSInteger)sp experience:(NSInteger)exp type:(NSInteger)t name:(NSString *)nameString {
    if((self = [super init])) {
        strengthPoints = sp;
        experience = exp;
        type = t;
        name = nameString;
    }
    return self;
}

#pragma what can this unit do?
-(BOOL)isInfantry {
    NSArray *infantryArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithInteger:unitInfantry],
                              [NSNumber numberWithInteger:unitCommander],
                              [NSNumber numberWithInteger:unitEngineer],
                              [NSNumber numberWithInteger:unitInfantryAntiTank],
                              [NSNumber numberWithInteger:unitMortar],
                              nil];
    for( NSNumber *n in infantryArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)canDamageArmor {
    NSArray *armorDamageArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithInteger:unitTank],
                              [NSNumber numberWithInteger:unitLightTank],
                              [NSNumber numberWithInteger:unitArmouredCar],
                              [NSNumber numberWithInteger:unitInfantryAntiTank],
                              [NSNumber numberWithInteger:unitMortar],
                              nil];
    for( NSNumber *n in armorDamageArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)has360ArcOfFire {
    NSArray *arcOfFire = [NSArray arrayWithObjects:
                                 [NSNumber numberWithInteger:unitTank],
                                 [NSNumber numberWithInteger:unitLightTank],
                                 [NSNumber numberWithInteger:unitArmouredCar],
                                 nil];
    for( NSNumber *n in arcOfFire ) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}
        
-(BOOL)isMotorized {
    NSArray *motorizedArray = [NSArray arrayWithObjects:
                                 [NSNumber numberWithInteger:unitTank],
                                 [NSNumber numberWithInteger:unitLightTank],
                                 [NSNumber numberWithInteger:unitArmouredCar],
                                 [NSNumber numberWithInteger:unitAntiAircraft],
                                 [NSNumber numberWithInteger:unitArtillerySelfPropelled],
                                 [NSNumber numberWithInteger:unitHalfTrack],
                                 [NSNumber numberWithInteger:unitTruck],
                                 nil];
    for( NSNumber *n in motorizedArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)isArmored {
    NSArray *armoredArray = [NSArray arrayWithObjects:
                             [NSNumber numberWithInteger:unitArmouredCar],
                             [NSNumber numberWithInteger:unitLightTank],
                             [NSNumber numberWithInteger:unitTank],
                             nil];
    for( NSNumber *n in armoredArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)isAntiAircraft {
    NSArray *antiAircraftArray = [NSArray arrayWithObjects:
                             [NSNumber numberWithInteger:unitAntiAircraft],
                             nil];
    for( NSNumber *n in antiAircraftArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)isArtillery {
    if([self isOnBoardArtillery] || [self isOffBoardArtillery]) {
        return YES;
    }
    return FALSE;
}

-(BOOL)isOnBoard {
    if ( type != unitArtilleryOffBoardLand && type != unitArtilleryOffBoardNaval ) {
        return YES;
    }
    return FALSE;
}

-(BOOL)isOffBoardArtillery {
    NSArray *offBoardArray = [NSArray arrayWithObjects:
                             [NSNumber numberWithInteger:unitArtilleryOffBoardLand],
                             [NSNumber numberWithInteger:unitArtilleryOffBoardNaval],
                             nil];
    for( NSNumber *n in offBoardArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)isOnBoardArtillery {
    NSArray *onBoardArray = [NSArray arrayWithObjects:
                             [NSNumber numberWithInteger:unitArtilleryOnBoardDrawn],
                             [NSNumber numberWithInteger:unitArtilleryOnBoardStatic],
                             [NSNumber numberWithInteger:unitArtillerySelfPropelled],
                             [NSNumber numberWithInteger:unitMortar],
                             nil];
    for( NSNumber *n in onBoardArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)canCarryInfantry {
    NSArray *carryArray = [NSArray arrayWithObjects:
                             [NSNumber numberWithInteger:unitHalfTrack],
                             [NSNumber numberWithInteger:unitTruck],
                             [NSNumber numberWithInteger:unitArmouredCar],
                             nil];
    for( NSNumber *n in carryArray) {
        if (type == [n integerValue]) {
            return  YES;
        }
    }
    return FALSE;
}

-(BOOL)canMove {
    if( type != unitArtilleryOnBoardStatic && [self isOnBoard] ) {
        return YES;
    }
    return FALSE;
}

-(BOOL)canMoveOnItsOwn {
    if( type != unitArtilleryOnBoardDrawn ) {
        return YES;
    }
    return FALSE;
}

-(BOOL)isCommander {
    if( type == unitCommander) {
        return YES;
    }
    return FALSE;
}

@end
