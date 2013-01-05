//
//  CharacterStat.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterStat : NSObject

@property (assign) NSInteger body;
@property (assign) NSInteger mind;
@property (assign) NSInteger instinct;
@property (assign) NSInteger heart;

@property (assign) NSInteger perception;
@property (assign) NSInteger action;
@property (assign) NSInteger desire;
@property (assign) NSInteger resistance;

@property (assign) NSInteger health;
@property (assign) NSInteger psychic;
@property (assign) NSInteger stamina;

@property (nonatomic, strong) NSString *reign;

-(id)initWithBody:(NSInteger)body instinct:(NSInteger)instinct heart:(NSInteger)heart mind:(NSInteger)mind perception:(NSInteger)perception action:(NSInteger)action desire:(NSInteger)desire resistance:(NSInteger)resistance health:(NSInteger)health stamina:(NSInteger)stamina psychic:(NSInteger)psychic reign:(NSString *)reign;

@end
