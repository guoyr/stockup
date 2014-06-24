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

@end


@implementation SBStocksTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 180, 44)];
        self.stockIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 180, 30)];
        
        [self.stockNameLabel setFont:[UIFont systemFontOfSize:20]];
        
        [self.stockIDLabel setTextColor:WHITE];
        [self.stockNameLabel setTextColor:WHITE];
        
        self.stockTrendLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 6, 96, 30)];
        if (arc4random() % 2 > 0) {
            self.stockTrendLabel.textColor = [UIColor greenColor];
            self.stockTrendLabel.text = @"+￥1.45";
        } else {
            self.stockTrendLabel.textColor = [UIColor redColor];
            self.stockTrendLabel.text = @"-￥2.98";
        }
        
        self.stockMiniTrendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 36, 96, 36)];
        [self.stockMiniTrendImageView setImage:[UIImage imageWithColor:BLUE_0]];
        
        [self addSubview:self.stockMiniTrendImageView];
        [self addSubview:self.stockTrendLabel];
        [self addSubview:self.stockIDLabel];
        [self addSubview:self.stockNameLabel];
        
        self.backgroundColor = BLUE_4;
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = BLACK;
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

@end
