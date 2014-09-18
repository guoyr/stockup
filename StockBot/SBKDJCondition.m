//
//  SBKDJAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBKDJCondition.h"
#import "SBAlgoConditionTableViewCell.h"

@interface SBKDJCondition()



@end

@implementation SBKDJCondition

-(id)init
{
    self = [super init];
    if (self) {
        self.conditionDescription = @"KDJ";
        self.conditionExplanation = @"随机指标KDJ一般是用于股票分析的统计体系，根据统计学原理，通过一个特定的周期（常为9日、9周等）内出现过的最高价、最低价及最后一个计算周期的收盘价及这三者之间的比例关系，来计算最后一个计算周期的未成熟随机值RSV，然后根据平滑移动平均线的方法来计算K值、D值与J值，并绘成曲线图来研判股票走势。";
    }
    return self;
}

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBKDJCondition *condition = [SBKDJCondition new];
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
            cell.descriptionLabel.text = @"KDJ时间设置";
            break;
        case 2:
            // direction
            cell.descriptionLabel.text = @"KDJ方向设置";
            break;
        default:
            break;
    }
}

-(int)numExpandedRows
{
    return 2;
}


@end
