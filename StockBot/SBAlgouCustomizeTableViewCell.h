//
//  SBAlgoTableViewCell.h
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBAlgouCustomizeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UISwitch *algoSwitch;
@property (nonatomic, strong) UISegmentedControl *algoSegmentedControl;

-(void)resetCell;

@end
