//
//  SBAlgorithm.h
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBConditions.h"


@interface SBAlgorithmManager : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSNumber *stockID;

@property (nonatomic, strong) SBMACDCondition *macdCondition;
@property (nonatomic, strong) SBKDJCondition *kdjCondition;
@property (nonatomic, strong) SBVolumeCondition *volumeCondtion;
@property (nonatomic, strong) SBBOLLCondition *bollCondition;
@property (nonatomic, strong) SBPriceCondition *priceCondition;

@property (nonatomic, strong) SBBuySellCondition *buySellCondition;
@property (nonatomic, strong) SBPriceTypeCondition *priceTypeCondition;

@property (nonatomic, assign) NSInteger numConditions;
@property (nonatomic, strong) NSString *uid;
// TODO: change to SBCondition subclass in the future

// array of mandatory controls for the algorithms
// show up as a list of segmentedIndices on the top
@property (nonatomic, strong) NSArray *mandatoryConditions;
// conditions that have been added to this algorithm
@property (nonatomic, strong) NSMutableArray *addedConditions;

-(NSDictionary *)archiveToDict;
-(void)unarchiveFromDict:(NSDictionary *)dict;

@end
