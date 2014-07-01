//
//  SBMACDAlgorithm.h
//  StockBot
//
//  Created by Robert Guo on 4/29/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBCondition.h"

@interface SBMACDCondition : SBCondition

@property (nonatomic, assign,readonly) NSInteger macdDirection;
@property (nonatomic, assign,readonly) NSInteger macdTime;

@end
