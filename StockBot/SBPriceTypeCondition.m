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
    self.segmentedControl.alpha = 0;
    self.segmentedControl.tintColor = GREY_LIGHT;
    [self.segmentedControl addTarget:self action:@selector(marketLimitedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(NSString *)archiveToString
{
    return self.priceType;
}

-(void)marketLimitedControlValueChanged:(SBSegmentedControl *)control
{
    [self.delegate conditionDidChange:self];
//    if (!control.isExpanded) {
        // showing only the summary
        
//    } else {
        switch (control.selectedSegmentIndex) {
            case MARKET_PRICE_INDEX:
                self.priceType = @"market";
                break;
            case LIMITED_PRICE_INDEX:
                self.priceType = @"limited";
                break;
            default:
                break;
        }
    
        
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.delegate conditionDidChange:self];
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
    
}

@end
