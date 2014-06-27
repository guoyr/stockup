//
//  SBVolumeCondition.m
//  StockBot
//
//  Created by Robert Guo on 6/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBVolumeCondition.h"
#import "SBAlgoConditionTableViewCell.h"

@interface SBVolumeCondition()

@end

@implementation SBVolumeCondition

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"交易量";
    }
    return self;
}

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBVolumeCondition *condition = [SBVolumeCondition new];
    return condition;
}

-(NSDictionary *)archiveToDict
{
    return @{};
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    [super setupCell:cell AtIndex:index];
    switch (index) {
        case 1:
            // time period: hour, day, month
            cell.descriptionLabel.text = @"交易量";
            cell.numberStepper.hidden = NO;
            cell.numberTextField.hidden = NO;
            break;
        default:
            break;
    }
}

-(int)numExpandedRows
{
    return 1;
}
@end
