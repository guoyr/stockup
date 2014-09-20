//
//  SBPriceCondition.m
//  StockBot
//
//  Created by Robert Guo on 6/28/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBPriceCondition.h"
#import "SBAlgoConditionTableViewCell.h"

@interface SBPriceCondition()

@property (nonatomic, assign) NSInteger priceTrend;
@property (nonatomic, assign) NSInteger window;

@end

@implementation SBPriceCondition

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBPriceCondition *condition = [SBPriceCondition new];
    return condition;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.conditionDescription = @"交易价格";
        self.conditionExplanation = @"选择您在购买该股票时的价格";
        self.priceTrend = -1;
        self.window = -1;
        self.price = nil;
        self.conditionTypeId = @"price_condition";
    }
    return self;
}

-(NSDictionary *)archiveToDict
{
    if (self.priceTrend != -1 && self.price != nil)
    return @{@"type": [self priceTrendString], @"price": self.price, @"window": @(self.window)};
    
    return @{};
}

-(int)numExpandedRows
{
    return 2;
}

-(NSString *)priceTrendString
{
    if (self.priceTrend == 0)
        return @"more_than";
    return @"less_than";
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    [super setupCell:cell AtIndex:index];
    switch (index) {
        case 1:
            cell.descriptionLabel.text = @"交易价格";
            cell.numberStepper.hidden = NO;
            cell.numberTextField.hidden = NO;
            [cell.numberStepper addTarget:self action:@selector(numberStepperValueChanged:) forControlEvents:UIControlEventValueChanged];
            break;
        case 2:
            cell.descriptionLabel.text = @"价格走势设置";
            [cell.algoSegmentedControl setHidden:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"大于" atIndex:0 animated:NO];
            [cell.algoSegmentedControl insertSegmentWithTitle:@"小于" atIndex:1 animated:NO];
            [cell.algoSegmentedControl addTarget:self action:@selector(priceTrendChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.algoSegmentedControl setSelectedSegmentIndex:self.priceTrend];
            break;
        case 3:
            cell.descriptionLabel.text = @"窗口大小";
            break;
        default:
            break;
    }
}

-(void)priceTrendChanged:(UISegmentedControl *)sender
{
    self.priceTrend = sender.selectedSegmentIndex;
}

-(void)numberStepperValueChanged:(UIStepper *)sender
{
    self.price = [NSString stringWithFormat:@"%.2f", sender.value];
}

@end
