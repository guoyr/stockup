//
//  SBAlgorithm.h
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBAlgoConditionTableViewCell;
@class SBCondition;

@protocol SBConditionDelegate <NSObject>

-(void)conditionDidChange:(SBCondition *)condition;

@end

@interface SBCondition : NSObject

@property (nonatomic, weak) id<SBConditionDelegate> delegate;

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *conditionExplanation;
@property (nonatomic, assign) BOOL isSelected;
// keep track of the previous cell and remove targets if necessary
@property (nonatomic, strong) SBAlgoConditionTableViewCell *previousCell;


-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index;
-(int)numExpandedRows;

-(NSString *)extendedDescription;

+(id)conditionWithDict:(NSDictionary *)dict;
-(NSDictionary *)archiveToDict;

@end
