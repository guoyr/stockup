//
//  SBAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgorithm.h"

@implementation SBAlgorithm

-(id)init
{
    self = [super init];
    if (self) {
        self.macdCondition = [[SBMACDCondition alloc] init];
        self.kdjCondition = [[SBKDJCondition alloc] init];
        self.transactionCondition = [[SBTransactionCondition alloc] init];
        self.numConditions = 3;
    }
    
    return self;
}

-(SBCondition *)conditionAtIndex:(NSInteger)index
{
    SBCondition *condition;
    switch (index) {
        case 0:
            condition = self.macdCondition;
            break;
        case 1:
            condition = self.kdjCondition;
            break;
        case 2:
            condition = self.transactionCondition;
            break;
        default:
            break;
    }
    return condition;
}

@end
