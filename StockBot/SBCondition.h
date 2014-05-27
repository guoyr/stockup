//
//  SBAlgorithm.h
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBAlgoConditionTableViewCell;

@interface SBCondition : NSObject <NSCoding>

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *expandedDescription;
@property (nonatomic, assign) BOOL isSelected;

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index;
-(int)numExpandedRows;

+(id)conditionWithDict:(NSDictionary *)dict;
-(NSDictionary *)archiveToDict;

@end
