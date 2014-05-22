//
//  SBAlgoSelectTableViewCell.m
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgoSelectTableViewCell.h"
#import "SBConstants.h"

@implementation SBAlgoSelectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = GREEN_4;
        self.textLabel.textColor = WHITE;
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 100, 20, 80, ALGO_ROW_HEIGHT-40)];
        [self.confirmButton setBackgroundColor:BLUE_0];
        [self.confirmButton setTitle:@"添加条件" forState:UIControlStateNormal];
        [self.confirmButton.layer setCornerRadius:5.0];
        [self addSubview:self.confirmButton];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

@end
