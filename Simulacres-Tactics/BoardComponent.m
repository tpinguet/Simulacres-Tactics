//
//  BoardComponent.m
//  Simulacres-Tactics
//
//  Created by thierry on 1/4/13.
//  Copyright (c) 2013 thierry. All rights reserved.
//

#import "BoardComponent.h"

@implementation BoardComponent

-(id)initWithColumns:(NSInteger)columns rows:(NSInteger)rows {
    if((self = [super init])) {
        self.columns = columns;
        self.rows = rows;
    }
    return self;
}

@end
