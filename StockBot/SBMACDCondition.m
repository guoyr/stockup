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

@interface SBMACDCondition()

@property (nonatomic, assign) NSInteger macdDirection;
@property (nonatomic, assign) NSInteger macdTime;

@end

@implementation SBMACDCondition

-(NSString *)expandedDescription
{
    NSString *macdDirectionString;
    
    if (self.macdDirection == MACD_DIRECTION_NEG) {
        macdDirectionString = @"正交";
    } else {
        macdDirectionString = @"反交";
    }
    return [NSString stringWithFormat:@"MACD%@", macdDirectionString];
}

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"MACD";
        self.macdDirection = -1;
        self.macdTime = -1;
    }
    return self;
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    [super setupCell:cell AtIndex:index];
    switch (index) {
        case 1:
            // diff: bigger -> smaller, smaller -> bigger
            // 正差离值，负差离值
            cell.descriptionLabel.text = @"MACD方向设置";
            [cell.algoSegmentedControl setHidden:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"正交" atIndex:MACD_DIRECTION_POS animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"负交" atIndex:MACD_DIRECTION_NEG animated:NO];
            [cell.algoSegmentedControl addTarget:self action:@selector(macdDirectionChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.algoSegmentedControl setSelectedSegmentIndex:self.macdDirection];
            break;
        case 2:
            cell.descriptionLabel.text = @"MACD时间设置";
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
}

-(void)macdTimeChanged:(UISegmentedControl *)sender
{
    self.macdTime = sender.selectedSegmentIndex;
}

-(void)macdDirectionChanged:(UISegmentedControl *)sender
{
    self.macdDirection = sender.selectedSegmentIndex;
}

-(int)numExpandedRows
{
    return 2;
}

@end