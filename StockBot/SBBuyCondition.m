//
//  SBBuy.m
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBBuyCondition.h"

@implementation SBBuyCondition

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"买入";
    }
    return self;
}

-(int)numExpandedRows
{
    return 0;
}

@end
