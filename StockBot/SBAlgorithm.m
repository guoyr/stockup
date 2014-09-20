//
//  SBAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgorithm.h"

#define MACD_KEY @"macd_condition"
#define KDJ_KEY @"kdj_condition"
#define PRICE_KEY @"price_condition"
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
        self.versionNumber = 0;
        
        self.allConditions = @[self.macdCondition, self.kdjCondition, self.bollCondition, self.priceCondition];
        
        self.numConditions = 5;
        

        self.tradeMethodCondition = [TradeMethodCondition new];
        self.priceTypeCondition = [SBPriceTypeCondition new];
        
        self.mandatoryConditions = @[self.tradeMethodCondition, self.priceTypeCondition];
    }
    
    return self;
}

-(NSDictionary *)archiveToDict
{
//    NSDictionary *transactionDict = [self.transactionCondition archiveToDict];
    
    NSMutableDictionary *conditions = [NSMutableDictionary new];
    for (SBCondition *condition in self.allConditions) {
        if ([condition isSelected]) [conditions setObject:[condition archiveToDict] forKey:condition.conditionTypeId];
    }
    
    return @{@"algo_id":self.uid,
             @"algo_v":@(self.versionNumber++),
             @"user_id": @"admin",
             @"stock_id": self.stockID,
             @"algo_name": self.name,
             @"price_type": [self.priceTypeCondition archiveToString],
             @"trade_method": [self.tradeMethodCondition archiveToString],
             @"volume": @(self.volumeCondtion.volume),
             @"primary_condition": self.primaryCondition.conditionTypeId,
             @"conditions": conditions
             };
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
