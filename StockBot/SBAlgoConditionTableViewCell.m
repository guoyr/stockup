//
//  SBAlgoTableViewCell.m
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgoConditionTableViewCell.h"
#import "SBConstants.h"

@interface SBAlgoConditionTableViewCell()

@end


@implementation SBAlgoConditionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = BLACK;
        
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ALGO_LIST_WIDTH-20, ALGO_ROW_HEIGHT)];
        self.bgView.backgroundColor = GREEN_3;
        [self.contentView addSubview:self.bgView];

        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ALGO_LIST_WIDTH - 40, ALGO_ROW_HEIGHT)];
        self.descriptionLabel.textColor = WHITE;
        [self.contentView addSubview:self.descriptionLabel];
        [self.descriptionLabel setHidden:YES];

        // size is ignored
        self.algoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 100, 30, 0, 0)];
        [self.contentView addSubview:self.algoSwitch];
        
        self.algoSegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 170, 30, 150, ALGO_ROW_HEIGHT - 60)];
        [self.contentView addSubview:self.algoSegmentedControl];
        
        self.numberSegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 170, 30, 100, ALGO_ROW_HEIGHT - 60)];
        
        [self.numberSegmentedControl insertSegmentWithTitle:@"—" atIndex:0 animated:NO];
        [self.numberSegmentedControl insertSegmentWithTitle:@"+" atIndex:1 animated:NO];
        
        [self.contentView addSubview:self.numberSegmentedControl];
        
        [self resetCell];

        
    }
    
    return self;
}

-(void)resetCell
{
    // set cell to factory state without any buttons or toggles showing
    self.algoSwitch.hidden = YES;
    self.algoSegmentedControl.hidden = YES;
    [self.algoSegmentedControl removeAllSegments];
}

@end
