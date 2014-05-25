//
//  SBStocksDataManager.h
//  StockBot
//
//  Created by Robert Guo on 2/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CHCSVParser.h>
@class SBStock;
@class SBUser;
@class SBAlgorithm;
@interface SBStocksDataManager : NSObject<CHCSVParserDelegate>

@property (nonatomic, strong) NSMutableArray *stocks;
@property (nonatomic, strong) SBStock *selectedStock;

+(id)sharedManager;
-(NSURL *)getKChartImageURLForStock:(SBStock *)stock;
-(NSURL *)getMACDImageURLForStock:(SBStock *)stock;
-(NSString *)getStockInfoURLStringForStock:(SBStock *)stock;

-(void)getAllAlgorithmsForUser:(SBUser *)user;
-(void)saveAlgorithm:(SBAlgorithm *)algorithm withName:(NSString *)name;

@end
