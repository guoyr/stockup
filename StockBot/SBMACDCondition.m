                        //
//  SBMACDAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/29/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBMACDCondition.h"
#import "SBAlgoConditionTableViewCell.h"
#import "SBConstants.h"

#define DIRECTION @"direction"
#define TIME @"time"

@interface SBMACDCondition()

@property (nonatomic, assign) NSInteger macdDirection;
@property (nonatomic, assign) NSInteger macdTime;

@end

@implementation SBMACDCondition

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBMACDCondition *condition = [SBMACDCondition new];
    condition.macdDirection = [(NSNumber *)dict[DIRECTION] integerValue];
    condition.macdTime = [(NSNumber *)dict[TIME] integerValue];
    return condition;
}

-(NSDictionary *)archiveToDict
{
    if (self.macdDirection && self.macdTime) {
        return @{DIRECTION: @(_macdDirection), TIME: @(_macdTime)};
    }
    return @{};
    
}

-(id)init
{
    self = [super init];
    if (self) {
        self.conditionDescription = @"MACD";
        self.conditionTypeId = @"macd_condition";
        self.macdDirection = -1;
        self.macdTime = -1;
        self.conditionExplanation = @"MACD称为指数平滑异同平均线，是从双移动平均线发展而来的，由快的移动平均线减去慢的移动平均线，MACD的意义和双移动平均线基本相同，但阅读起来更方便。当MACD从负数转向正数，是买的信号。当MACD从正数转向负数，是卖的信号。当MACD以大角度变化，表示快的移动平均线和慢的移动平均线的差距非常迅速的拉开，代表了一个市场大趋势的转变。";
    }
    return self;
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    [super setupCell:cell AtIndex:index];
    
    if (self.previousCell) {
        
        // TODO: we need more than one previousCells and investigate into why we can't add target again once its been removed
        
//        [self.previousCell.algoSegmentedControl removeTarget:self action:@selector(macdDirectionChanged:) forControlEvents:UIControlEventValueChanged];
//        [self.previousCell.algoSegmentedControl removeTarget:self action:@selector(macdTimeChanged:) forControlEvents:UIControlEventValueChanged];

    }
    
    switch (index) {
        case 1:
            // diff: bigger -> smaller, smaller -> bigger
            // 正差离值，负差离值
            cell.descriptionLabel.text = @"方向设置";
            [cell.algoSegmentedControl setHidden:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"正交" atIndex:MACD_DIRECTION_POS animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"负交" atIndex:MACD_DIRECTION_NEG animated:NO];
            [cell.algoSegmentedControl addTarget:self action:@selector(macdDirectionChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.algoSegmentedControl setSelectedSegmentIndex:self.macdDirection];
            break;
        case 2:
            cell.descriptionLabel.text = @"时间设置";
            [cell.algoSegmentedControl setHidden:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"5分钟" atIndex:MACD_TIME_5MIN animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"1小时" atIndex:MACD_TIME_1HOUR animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"1天" atIndex:MACD_TIME_1DAY animated:NO];
            [cell.algoSegmentedControl addTarget:self action:@selector(macdTimeChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.algoSegmentedControl setSelectedSegmentIndex:self.macdTime];
            break;
        default:
            break;
    }
    
    self.previousCell = cell;
}

-(void)macdTimeChanged:(UISegmentedControl *)sender
{
    self.macdTime = sender.selectedSegmentIndex;
    [self.delegate conditionDidChange:self];
}

-(void)macdDirectionChanged:(UISegmentedControl *)sender
{
    self.macdDirection = sender.selectedSegmentIndex;
    [self.delegate conditionDidChange:self];
}

-(int)numExpandedRows
{
    return 2;
}

// describes what the user has selected

-(NSString *)extendedDescription
{
    NSString *direction;
    switch (self.macdDirection) {
        case MACD_DIRECTION_NEG:
            direction = @"负交";
            break;
        case MACD_DIRECTION_POS:
            direction = @"正交";
            break;
        default:
            
            break;
    }
    if (direction) {
        return [NSString stringWithFormat:@"MACD月线与5分线%@时",direction];
    }
    return nil;
}

@end