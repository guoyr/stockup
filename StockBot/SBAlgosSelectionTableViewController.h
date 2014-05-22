//
//  SBAlgosListTableViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBCondition.h"

@class SBAlgosSelectionTableViewController;

@protocol SBAlgosListTableViewControllerDelegate <NSObject>

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didSelectAlgorithm:(SBCondition *)algorithm;
-(void)viewController:(SBAlgosSelectionTableViewController *)vc didViewAlgorithm:(SBCondition *)algorithm;

@end

@interface SBAlgosSelectionTableViewController : UITableViewController

@property (nonatomic, weak) NSObject<SBAlgosListTableViewControllerDelegate> *delegate;


@end
