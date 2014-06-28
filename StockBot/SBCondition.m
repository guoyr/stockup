//
//  SBAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBCondition.h"
#import "SBAlgoConditionTableViewCell.h"
#import "SBConstants.h"

@implementation SBCondition


+(id)conditionWithDict:(NSDictionary *)dict
{
    return nil;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    cell.numberSegmentedControl.hidden = YES;
    cell.numberStepper.hidden = YES;
    cell.numberTextField.hidden = YES;
}

-(int)numExpandedRows
{   
    return 0;
}

-(NSDictionary *)archiveToDict
{
    return nil;
}

@end