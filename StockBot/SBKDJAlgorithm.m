//
//  SBKDJAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBKDJAlgorithm.h"

@implementation SBKDJAlgorithm

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"KDJ";
    }
    return self;
}

-(void)setupCell:(UITableViewCell *)cell AtIndex:(NSInteger)index
{
    switch (index) {
        case 1:
            // time period: hour, day, month
            cell.textLabel.text = @"KDJ时间设置";
            break;
        case 2:
            // direction
            cell.textLabel.text = @"KDJ方向设置";
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
