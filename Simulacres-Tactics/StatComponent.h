//
//  StatComponent.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "Component.h"
#import "CharacterStat.h"

@interface StatComponent : Component

@property (nonatomic, strong) CharacterStat *stat;

-(id)initWithStat:(CharacterStat *)stat;

@end
