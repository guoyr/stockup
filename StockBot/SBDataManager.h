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

@interface SBDataManager : NSObject<CHCSVParserDelegate>

@property (nonatomic, strong) NSMutableArray *stocks;
@property (nonatomic, strong) NSArray *brokerList;
@property (nonatomic, strong) NSString *authCookie;

+(id)sharedManager;

-(NSDictionary *)getAllAlgorithmsForUser:(SBUser *)user;

-(void)saveAlgorithm:(SBAlgorithm *)algorithm;
-(void)removeAlgorithm:(NSString *)algorithmName;

-(NSString *)defaultAlgorithmName;

@end
