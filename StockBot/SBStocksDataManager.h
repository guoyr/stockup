//
//  SBStocksDataManager.h
//  StockBot
//
//  Created by Robert Guo on 2/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CHCSVParser.h>

@interface SBStocksDataManager : NSObject<CHCSVParserDelegate>

@property (nonatomic, strong) NSMutableArray *stocks;

+(id)sharedManager;

@end
