//
//  SBStocksDataManager.h
//  StockBot
//
//  Created by Robert Guo on 2/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBStocksDataManager : NSObject

@property (nonatomic, strong) NSArray *stocksList;

+(id)sharedManager;

@end
