//
//  SBAlgoTableViewCell.h
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBAlgoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end
