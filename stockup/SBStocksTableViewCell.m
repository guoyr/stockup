//
//  SBStocksTableViewCell.m
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBStocksTableViewCell.h"
#import "SBConstants.h"
#import "UIImage+SBAdditions.h"

@interface SBStocksTableViewCell()

@property (nonatomic, strong) UIView *bgView;

@end


@implementation SBStocksTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STOCK_CELL_WIDTH, STOCK_CELL_HEIGHT)];
        self.bgView.backgroundColor = GREY_DARK;
        self.bgView.layer.borderColor = BLACK_BG.CGColor;
        self.bgView.layer.borderWidth = 2;

        self.stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 180, 44)];
        self.stockIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 30)];
        [self.stockNameLabel setFont:[UIFont systemFontOfSize:20]];
        self.stockIDLabel.font = [UIFont boldSystemFontOfSize:24];
        [self.stockIDLabel setTextColor:WHITE];
        [self.stockNameLabel setTextColor:WHITE];
        self.stockIDLabel.backgroundColor = [UIColor clearColor];
        self.stockNameLabel.backgroundColor = [UIColor clearColor];
        self.stockTrendLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 6, 96, 30)];
        if (arc4random() % 2 > 0) {
            self.stockTrendLabel.textColor = [UIColor greenColor];
            self.stockTrendLabel.text = @"+￥1.45";
        } else {
            self.stockTrendLabel.textColor = [UIColor redColor];
            self.stockTrendLabel.text = @"-￥2.98";
        }
        
        self.stockMiniTrendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 36, 96, 36)];
        [self.stockMiniTrendImageView setImage:[UIImage imageNamed:@"stock_trend_mini_dummy"]];
        
        
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.stockMiniTrendImageView];
        [self.contentView addSubview:self.stockTrendLabel];
        [self.contentView addSubview:self.stockIDLabel];
        [self.contentView addSubview:self.stockNameLabel];
        
        
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = BLACK_BG;
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

@end
