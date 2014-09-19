//
//  SBBuySellCondition.h
//  StockBot
//
//  Created by Robert Guo on 7/5/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBMandatoryCondition.h"

@interface TradeMethodCondition : SBMandatoryCondition

@property (nonatomic, strong) NSString *tradeMethod;

@end
