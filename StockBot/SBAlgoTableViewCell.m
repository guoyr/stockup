//
//  SBAlgoTableViewCell.m
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgoTableViewCell.h"
#import "SBConstants.h"

@interface SBAlgoTableViewCell()

@end


@implementation SBAlgoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BLUE_4;
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 100, 20, 80, ALGO_ROW_HEIGHT-40)];
        [self.confirmButton setBackgroundColor:BLUE_0];
        [self.confirmButton setTitle:@"添加条件" forState:UIControlStateNormal];
        [self.confirmButton.layer setCornerRadius:5.0];
        
        self.descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALGO_LIST_WIDTH, ALGO_ROW_HEIGHT)];
        self.descriptionView.backgroundColor = BLUE_3;
        
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(10, ALGO_ROW_HEIGHT, ALGO_LIST_WIDTH-20, ALGO_EXPANDED_ROW_HEIGHT - ALGO_ROW_HEIGHT)];
        self.detailView.backgroundColor = BLUE_4;
        
        [self.descriptionView addSubview:self.confirmButton];
        [self.contentView addSubview:self.descriptionView];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    BOOL prevSelectedState = self.selected;
    [super setSelected:selected animated:animated];
    if (selected == prevSelectedState) return;
    if (selected) {
        [self.contentView addSubview:self.detailView];
    } else {
        [self.detailView removeFromSuperview];
    }
}

@end
