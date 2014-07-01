//
//  SBBOLLCondition.m
//  StockBot
//
//  Created by Robert Guo on 6/28/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBBOLLCondition.h"
#import "SBAlgoConditionTableViewCell.h"

@implementation SBBOLLCondition

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBBOLLCondition *condition =[SBBOLLCondition new];
    return condition;
}

-(id)init
{
    self = [super init];
    if (self) {
        //
        self.description = @"布林线指标";
        self.conditionExplanation = @"布林线指标，即BOLL指标，其英文全称是“Bollinger Bands”，布林线(BOLL)由约翰 布林先生创造，其利用统计原理，求出股价的标准差及其信赖区间，从而确定股价的波动范围及未来走势，利用波带显示股价的安全高低价位，因而也被称为布林带。其上下限范围不固定，随股价的滚动而变化。布林指标和麦克指标MIKE一样同属路径指标，股价波动在上限和下限的区间之内，这条带状区的宽窄，随着股价波动幅度的大小而变化，股价涨跌幅度加大时，带状区变宽，涨跌幅度狭小盘整时，带状区则变窄。";
        
    }
    
    return self;
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
            cell.descriptionLabel.text = @"轴线";
            cell.algoSegmentedControl.hidden = NO;
            [cell.algoSegmentedControl insertSegmentWithTitle:@"上轨" atIndex:0 animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"中轨" atIndex:1 animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"下轨" atIndex:2 animated:NO];
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
