//
//  SBMACDAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/29/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBMACDAlgorithm.h"

@implementation SBMACDAlgorithm

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"MACD";
    }
    return self;
}

-(void)setupCell:(UITableViewCell *)cell AtIndex:(NSInteger)index
{
    switch (index) {
        case 1:
            // diff: bigger -> smaller, smaller -> bigger
            // 正差离值，负差离值
            cell.textLabel.text = @"MACD方向设置";
            break;
        case 2:
            cell.textLabel.text = @"MACD时间设置";
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
