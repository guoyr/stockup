//
//  SBAlgorithm.h
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBConditions.h"


@interface SBAlgorithm : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSNumber *stockID;
@property (nonatomic, strong) SBMACDCondition *macdCondition;
@property (nonatomic, strong) SBKDJCondition *kdjCondition;
@property (nonatomic, strong) SBTransactionCondition *transactionCondition;
@property (nonatomic, assign) NSInteger numConditions;
@property (nonatomic, strong) NSString *uid;

-(SBCondition *)conditionAtIndex:(NSInteger)index;

-(NSDictionary *)archiveToDict;
-(void)unarchiveFromDict:(NSDictionary *)dict;

@end
