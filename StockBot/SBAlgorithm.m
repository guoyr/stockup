//
//  SBAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgorithm.h"

#define MACD_KEY @"macd_key"
#define KDJ_KEY @"kdj_key"
#define TRANSACTION_KEY @"transacion_key"

@implementation SBAlgorithm

-(id)init
{
    self = [super init];
    if (self) {
        self.macdCondition = [SBMACDCondition new];
        self.kdjCondition = [SBKDJCondition new];
//        self.transactionCondition = [SBTransactionCondition new];
        self.numConditions = 3;
    }
    
    return self;
}

-(NSDictionary *)archiveToDict
{
    NSDictionary *macdDict = [self.macdCondition archiveToDict];
    NSDictionary *kdjDict = [self.kdjCondition archiveToDict];
//    NSDictionary *transactionDict = [self.transactionCondition archiveToDict];

    return @{MACD_KEY:macdDict, KDJ_KEY:kdjDict};
}

-(void)unarchiveFromDict:(NSDictionary *)dict
{
    NSDictionary *macdDict = dict[MACD_KEY];
    NSDictionary *kdjDict = dict[KDJ_KEY];
//    NSDictionary *transactionDict = dict[TRANSACTION_KEY];
    
    self.macdCondition = [SBMACDCondition conditionWithDict:macdDict];
    self.kdjCondition = [SBKDJCondition conditionWithDict:kdjDict];
//    self.transactionCondition = [SBTransactionCondition conditionWithDict:transactionDict];
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
//        case 2:
//            condition = self.transactionCondition;
            break;
        default:
            break;
    }
    return condition;
}

@end
