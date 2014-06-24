//
//  SBStock.h
//  StockBot
//
//  Created by Robert Guo on 3/14/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBStock : NSObject

@property (nonatomic, strong) NSString *name; //0
@property (nonatomic, strong) NSNumber *stockID;
@property (nonatomic, strong) NSString *stockIDString;
@property (nonatomic, strong) NSDate *fetchDate;
@property (nonatomic, strong) NSNumber *todayOpeningPrice; //1
@property (nonatomic, strong) NSNumber *yesterdayClosingPrice; //2
@property (nonatomic, strong) NSNumber *todayHigh; //4
@property (nonatomic, strong) NSNumber *todayLow; //5
// following fields represent time of data fetch
// will probably need to separate this model into current stock info
// and historic stock info
@property (nonatomic, strong) NSNumber *currentPrice; //3
@property (nonatomic, strong) NSNumber *buyPrice; //6
@property (nonatomic, strong) NSNumber *sellPrice; //7
@property (nonatomic, strong) NSNumber *volume; //8

@property (nonatomic, strong) NSIndexPath *tableViewIndex;

-(void)updateInfoFromSinaData:(NSString *)rawData;

@end
