//
//  SBAlgorithm.h
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBConditions.h"
@class SBStock;

@interface SBAlgorithm : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *stockID;
@property (nonatomic, assign) int versionNumber;

@property (nonatomic, strong) SBMACDCondition *macdCondition;
@property (nonatomic, strong) SBKDJCondition *kdjCondition;
@property (nonatomic, strong) SBVolumeCondition *volumeCondtion;
@property (nonatomic, strong) SBBOLLCondition *bollCondition;
@property (nonatomic, strong) SBPriceCondition *priceCondition;

@property (nonatomic, strong) SBCondition *primaryCondition;

@property (nonatomic, strong) SBTradeMethodCondition *tradeMethodCondition;
@property (nonatomic, strong) SBPriceTypeCondition *priceTypeCondition;

@property (nonatomic, assign) NSInteger numConditions;
@property (nonatomic, strong) NSString *uid;
// TODO: change to SBCondition subclass in the future

// array of mandatory controls for the algorithms
// show up as a list of segmentedIndices on the top
@property (nonatomic, strong) NSArray *mandatoryConditions;
// conditions that have been added to this algorithm
@property (nonatomic, strong) NSArray *allConditions;

+(SBAlgorithm *)algorithmFromDict:(NSDictionary *)dict;

-(NSDictionary *)archiveToDict;

@end
