//
//  SBStocksListTableViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"
@class SBStock;
@class SBStocksListTableViewController;

@protocol SBStocksListTableViewControllerDelegate <NSObject>

-(void)viewController:(SBStocksListTableViewController *)vc didSelectStock:(SBStock *)stock;

@end

@interface SBStocksListTableViewController : SBTableViewController <UISearchBarDelegate>

@property (nonatomic, weak) NSObject<SBStocksListTableViewControllerDelegate> *delegate;

@end

