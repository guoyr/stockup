//
//  SBStocksDataManager.m
//  StockBot
//
//  Created by Robert Guo on 2/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBStocksDataManager.h"

@implementation SBStocksDataManager

+ (id)sharedManager {
    static SBStocksDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(id)init
{
    self = [super init];
    if (self) {
        self.stocksList = @[@"中信银行",@"招商银行",@"建设银行",@"比亚迪",@"中信银行",@"招商银行",@"建设银行",@"比亚迪",@"中信银行",@"招商银行",@"建设银行",@"比亚迪",@"中信银行",@"招商银行",@"建设银行",@"比亚迪",@"中信银行",@"招商银行",@"建设银行",@"比亚迪",@"中信银行",@"招商银行",@"建设银行",@"比亚迪",@"中信银行",@"招商银行",@"建设银行",@"比亚迪"];
    }
    
    return self;
}

@end
