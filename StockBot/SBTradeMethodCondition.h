//
//  SBBuySellCondition.h
//  StockBot
//
//  Created by Robert Guo on 7/5/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBMandatoryCondition.h"

@interface SBTradeMethodCondition : SBMandatoryCondition

@property (nonatomic, strong) NSString *tradeMethod;

@end
