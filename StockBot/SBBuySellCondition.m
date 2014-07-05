//
//  SBBuySellCondition.m
//  StockBot
//
//  Created by Robert Guo on 7/5/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBBuySellCondition.h"
#import "SBConstants.h"

#define BUY_INDEX 0
#define SELL_INDEX 1

@implementation SBBuySellCondition

-(void)setupSegmentedControl
{
    self.segmentedControl = [[SBSegmentedControl alloc] initWithItems:@[@"买入", @"卖出"]];
    self.segmentedControl.alpha = 0.0f;
    self.segmentedControl.tintColor = GREY_LIGHT;
    [self.segmentedControl addTarget:self action:@selector(buySellControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)buySellControlValueChanged:(SBSegmentedControl *)sender
{
    [self.delegate conditionDidChange:self];
    
//    switch (sender.selectedSegmentIndex) {
//        case BUY_INDEX:
//            self.stockTintColor = BLUE;
//            break;
//        case SELL_INDEX:
//            self.stockTintColor = RED;
//            break;
//        default:
//            break;
//    }
//    self.priceControl.tintColor = self.stockTintColor;
//    self.buySellControl.tintColor = self.stockTintColor;
//    self.navigationController.navigationBar.barTintColor = self.stockTintColor;
//    [self.tableView reloadData];
//    self.algorithm.buySellCondition = control.selectedSegmentIndex + 1;
}

@end
