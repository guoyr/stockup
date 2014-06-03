//
//  SBBuy.m
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBTransactionCondition.h"
#import "SBAlgoConditionTableViewCell.h"

#define CONDITION @"condition"

@interface SBTransactionCondition()

@property (nonatomic, assign) NSInteger transactionCondition;

@end

@implementation SBTransactionCondition

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBTransactionCondition *condition = [SBTransactionCondition new];
    condition.transactionCondition = [(NSNumber *)dict[CONDITION] integerValue];
    return condition;
}

-(NSDictionary *)archiveToDict
{
    return @{CONDITION:[NSNumber numberWithInteger:_transactionCondition]};
}

-(id)init
{
    self = [super init];
    if (self) {
        self.description = @"交易条件";
        self.transactionCondition = -1;
    }
    return self;
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    [super setupCell:cell AtIndex:index];
    switch (index) {
        case 1:
            cell.descriptionLabel.text = @"买入或卖出";
            cell.algoSegmentedControl.hidden = NO;
            [cell.algoSegmentedControl insertSegmentWithTitle:@"买入" atIndex:BUY_CONDITION animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"卖出" atIndex:SELL_CONDITION animated:NO];
            [cell.algoSegmentedControl addTarget:self action:@selector(transactionConditionChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.algoSegmentedControl setSelectedSegmentIndex:self.transactionCondition];
            break;
            
        default:
            break;
    }
}

-(void)transactionConditionChanged:(UISegmentedControl *)sender
{
    self.transactionCondition = sender.selectedSegmentIndex;
}

-(int)numExpandedRows
{
    return 1;
}

@end
