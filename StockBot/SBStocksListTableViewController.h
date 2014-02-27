//
//  SBStocksListTableViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBStocksListTableViewController;

@protocol SBStocksListTableViewControllerDelegate <NSObject>

-(void)viewController:(SBStocksListTableViewController *)vc didSelectStock:(NSString *)stock;

@end

@interface SBStocksListTableViewController : UITableViewController

@property (nonatomic, weak) NSObject<SBStocksListTableViewControllerDelegate> *delegate;

@end

