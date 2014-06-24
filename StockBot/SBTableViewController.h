//
//  SBTableViewController.h
//  StockBot
//
//  Created by Robert Guo on 6/24/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

-initWithStyle:(UITableViewStyle)style;

@end
