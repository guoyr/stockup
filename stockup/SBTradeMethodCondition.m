//
//  SBBuySellCondition.m
//  StockBot
//
//  Created by Robert Guo on 7/5/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBTradeMethodCondition.h"
#import "SBConstants.h"

#define BUY_INDEX 0
#define SELL_INDEX 1

@implementation SBTradeMethodCondition

-(void)setupSegmentedControl:(SBSegmentedControl *)segmentedControl
{
    [segmentedControl insertSegmentWithTitle:@"卖出" atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithTitle:@"买入" atIndex:0 animated:NO];
    segmentedControl.alpha = 0.0f;
    segmentedControl.tintColor = GREY_LIGHT;
    [segmentedControl addTarget:self action:@selector(buySellControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(NSString *)archiveToString
{
    return self.tradeMethod;
}

+(SBCondition *)conditionFromString:(NSString *)conditionString
{
    SBTradeMethodCondition *condition = [SBTradeMethodCondition new];
    condition.tradeMethod = conditionString;
    return condition;
}

-(void)buySellControlValueChanged:(SBSegmentedControl *)sender
{
    [self.delegate conditionDidChange:self];
    
    switch (sender.selectedSegmentIndex) {
        case BUY_INDEX:
            self.tradeMethod = @"buy";
            break;
        case SELL_INDEX:
            self.tradeMethod = @"sell";
            break;
        default:
            break;
    }
//    self.priceControl.tintColor = self.stockTintColor;
//    self.buySellControl.tintColor = self.stockTintColor;
//    self.navigationController.navigationBar.barTintColor = self.stockTintColor;
//    [self.tableView reloadData];
//    self.algorithm.buySellCondition = control.selectedSegmentIndex + 1;
}

@end
