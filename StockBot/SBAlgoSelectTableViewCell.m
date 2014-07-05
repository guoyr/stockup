//
//  SBAlgoSelectTableViewCell.m
//  StockBot
//
//  Created by Robert Guo on 5/22/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgoSelectTableViewCell.h"
#import "SBConstants.h"

@interface SBAlgoSelectTableViewCell()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation SBAlgoSelectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = GREY_DARK;
        self.textLabel.textColor = GREY_LIGHT;
 
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALGO_LIST_WIDTH, ALGO_ROW_HEIGHT)];
        self.bgView.backgroundColor = [UIColor clearColor];
        self.bgView.layer.borderColor = BLACK_BG.CGColor;
        self.bgView.layer.borderWidth = 2;
        [self.contentView addSubview:self.bgView];
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 60, 20, ALGO_ROW_HEIGHT - 40, ALGO_ROW_HEIGHT-40)];

        [self.confirmButton setTitle:@"+" forState:UIControlStateNormal];
        [self.confirmButton.layer setCornerRadius:10.0];
        self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
        self.confirmButton.titleLabel.textColor = GREY_LIGHT;
        
        self.confirmButton.layer.borderColor = [GREY_DARK CGColor];
        self.confirmButton.backgroundColor = [UIColor clearColor];
        self.confirmButton.layer.borderWidth = 2;
        [self addSubview:self.confirmButton];
        

    }
    return self;
}

-(void)setConfirmButtonTitle:(NSString *)title
{
    self.confirmButton.titleLabel.text = title;
}


-(void)setStockTintColor:(UIColor *)color
{
    self.confirmButton.titleLabel.textColor = color;
    self.confirmButton.layer.borderColor = [color CGColor];

}

- (void)awakeFromNib
{
    // Initialization code
}

@end
