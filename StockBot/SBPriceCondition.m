//
//  SBPriceCondition.m
//  StockBot
//
//  Created by Robert Guo on 6/28/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBPriceCondition.h"
#import "SBAlgoConditionTableViewCell.h"
@implementation SBPriceCondition

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBPriceCondition *condition = [SBPriceCondition new];
    return condition;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"交易价格";
        self.expandedDescription = @"选择您在购买该股票时的价格";
    }
    return self;
}

-(NSDictionary *)archiveToDict
{
    return @{};
}

-(int)numExpandedRows
{
    return 1;
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    [super setupCell:cell AtIndex:index];
    switch (index) {
        case 1:
            cell.descriptionLabel.text = @"交易价格";
            break;
            
        default:
            break;
    }
}

@end
