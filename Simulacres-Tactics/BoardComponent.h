//
//  BoardComponent.h
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "Component.h"

@interface BoardComponent : Component

@property (assign) NSInteger columns;
@property (assign) NSInteger rows;

-(id)initWithColumns:(NSInteger)columns rows:(NSInteger)rows;

@end
