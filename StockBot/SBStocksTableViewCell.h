//
//  SBStocksTableViewCell.h
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBStocksTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *stockNameLabel;
@property (nonatomic, strong) UILabel *stockIDLabel;

@property (nonatomic, strong) UIImageView *stockMiniTrendImageView;
@property (nonatomic, strong) UILabel *stockTrendLabel;

@end
