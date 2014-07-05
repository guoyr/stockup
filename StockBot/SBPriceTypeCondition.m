//
//  SBPriceTypeCondition.m
//  StockBot
//
//  Created by Robert Guo on 7/5/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBPriceTypeCondition.h"

#define MARKET_PRICE_INDEX 0
#define LIMITED_PRICE_INDEX 1

@implementation SBPriceTypeCondition

-(void)setupSegmentedControl
{
    self.segmentedControl = [[SBSegmentedControl alloc] initWithItems:@[@"市场价",@"限价单"]];
    self.segmentedControl.frame = CGRectMake(HEADER_BORDER, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
    self.segmentedControl.alpha = 0.0f;
    self.segmentedControl.tintColor = GREY_LIGHT;
    [self.segmentedControl addTarget:self action:@selector(marketLimitedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)marketLimitedControlValueChanged:(SBSegmentedControl *)control
{
    if (!control.isExpanded) {
        // showing only the summary
        
    } else {
        switch (control.selectedSegmentIndex) {
            case MARKET_PRICE_INDEX:
                ;
                break;
            case LIMITED_PRICE_INDEX:
                ;
                break;
            default:
                break;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.delegate conditionDidChange:self];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

@end
