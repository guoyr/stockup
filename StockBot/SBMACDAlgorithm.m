//
//  SBMACDAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/29/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBMACDAlgorithm.h"
#import "SBAlgouCustomizeTableViewCell.h"
#import "SBConstants.h"

@interface SBMACDAlgorithm()

@property (nonatomic, assign) NSInteger macdDirection;

@end

@implementation SBMACDAlgorithm

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"MACD";
    }
    return self;
}

-(void)setupCell:(SBAlgouCustomizeTableViewCell *)cell AtIndex:(NSInteger)index
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
            [cell.algoSegmentedControl setSelectedSegmentIndex:0];
            break;
        case 2:
            cell.descriptionLabel.text = @"MACD时间设置";
            break;
        default:
            break;
    }
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
