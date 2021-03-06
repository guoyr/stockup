//
//  SBKDJAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBKDJCondition.h"
#import "SBAlgoConditionTableViewCell.h"

@interface SBKDJCondition()

@property (nonatomic, assign) NSInteger n;
@property (nonatomic, assign) NSInteger m;
@property (nonatomic, assign) NSInteger m1;

@end

@implementation SBKDJCondition

-(id)init
{
    self = [super init];
    if (self) {
        self.conditionDescription = @"KDJ";
        self.conditionExplanation = @"随机指标KDJ一般是用于股票分析的统计体系，根据统计学原理，通过一个特定的周期（常为9日、9周等）内出现过的最高价、最低价及最后一个计算周期的收盘价及这三者之间的比例关系，来计算最后一个计算周期的未成熟随机值RSV，然后根据平滑移动平均线的方法来计算K值、D值与J值，并绘成曲线图来研判股票走势。";
        self.conditionTypeId = @"kdj_condition";
    }
    return self;
}


-(NSString *)extendedDescription
{
    return [NSString stringWithFormat:@"KDJ其中n=%ld秒,m=%ld秒,m1=%ld秒",(long)self.n, (long)self.m, (long)self.m1];
}

+(id)conditionWithDict:(NSDictionary *)dict
{
    SBKDJCondition *condition = [SBKDJCondition new];
    condition.n = [dict[@"n"] integerValue];
    condition.m = [dict[@"m"] integerValue];
    condition.m1 = [dict[@"m1"] integerValue];
    return condition;
}


-(NSDictionary *)archiveToDict
{
    return @{@"n":@(self.n), @"m": @(self.m), @"m1": @(self.m1)};
}

-(void)setupCell:(SBAlgoConditionTableViewCell *)cell AtIndex:(NSInteger)index
{
    [super setupCell:cell AtIndex:index];
    cell.numberStepper.stepValue = 5;
    cell.numberStepper.minimumValue = 0;
    cell.numberStepper.hidden = NO;
    cell.numberTextField.hidden = NO;
    
    switch (index) {
        case 1:
            // time period: hour, day, month
            cell.descriptionLabel.text = @"n（秒）";
            cell.numberStepper.tag = 0; // use the tag to identify which cell it is
            break;
        case 2:
            // direction
            cell.descriptionLabel.text = @"m（秒）";
            cell.numberStepper.tag = 1;
            break;
        case 3:
            // direction
            cell.descriptionLabel.text = @"m1（秒）";
            cell.numberStepper.tag = 2;
            break;
        default:
            break;
    }
    [cell.numberStepper addTarget:self action:@selector(numberStepperValueChanged:) forControlEvents:UIControlEventValueChanged];

}

-(void)numberStepperValueChanged:(UIStepper *)sender
{
    switch (sender.tag) {
        case 0:
            self.n = (int)sender.value;
            break;
        case 1:
            self.m = (int)sender.value;
            break;
        case 2:
            self.m1 = (int)sender.value;
            break;
        default:
            break;
    }
    [self.delegate conditionDidChange:self];
}

-(int)numExpandedRows
{
    return 3;
}


@end
