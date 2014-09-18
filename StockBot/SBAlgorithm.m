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
        self.bollCondition = [SBBOLLCondition new];
        self.volumeCondtion = [SBVolumeCondition new];
        self.priceCondition = [SBPriceCondition new];
        
        self.numConditions = 5;
        self.addedConditions = [NSMutableArray new];

        self.buySellCondition = [SBBuySellCondition new];
        self.priceTypeCondition = [SBPriceTypeCondition new];
        
        self.mandatoryConditions = @[self.buySellCondition, self.priceTypeCondition];
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


@end
