//
//  SBMandatoryCondition.h
//  StockBot
//
//  Created by Robert Guo on 7/5/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBCondition.h"
#import "SBSegmentedControl.h"

#define HEADER_BORDER 12
#define SEG_CONTROL_WIDTH ALGO_LIST_WIDTH/2-HEADER_BORDER*2

@interface SBMandatoryCondition : SBCondition

@property (nonatomic, strong) SBSegmentedControl *segmentedControl;

-(void)setupSegmentedControl;
-(NSString *)archiveToString;
+(SBCondition *)conditionFromString:(NSString *)conditionString;

@end
