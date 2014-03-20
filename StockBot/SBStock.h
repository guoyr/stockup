//
//  SBStock.h
//  StockBot
//
//  Created by Robert Guo on 3/14/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBStock : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *stockID;
@property (nonatomic, strong) NSDate *fetchDate;
@property (nonatomic, strong) NSNumber *todayOpeningPrice;
@property (nonatomic, strong) NSNumber *yesterdayClosingPrice;
@property (nonatomic, strong) NSNumber *todayHigh;
@property (nonatomic, strong) NSNumber *todayLow;
// following fields represent time of data fetch
// will probably need to separate this model into current stock info
// and historic stock info
@property (nonatomic, strong) NSNumber *currentPrice;
@property (nonatomic, strong) NSNumber *buyPrice;
@property (nonatomic, strong) NSNumber *sellPrice;
@property (nonatomic, strong) NSNumber *volume;



@end
