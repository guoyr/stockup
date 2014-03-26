//
//  SBStocksTableViewCell.m
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBStocksTableViewCell.h"
#import "SBConstants.h"

@interface SBStocksTableViewCell()


@end


@implementation SBStocksTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 44)];
        self.stockIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 180, 30)];
        
        [self.stockNameLabel setFont:[UIFont systemFontOfSize:20]];
        
        [self.stockIDLabel setTextColor:WHITE];
        [self.stockNameLabel setTextColor:WHITE];
        
        [self addSubview:self.stockIDLabel];
        [self addSubview:self.stockNameLabel];
        
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

@end
