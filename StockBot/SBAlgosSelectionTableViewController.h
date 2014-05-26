//
//  SBAlgosListTableViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBCondition;
@class SBAlgosSelectionTableViewController;

@protocol SBAlgosSelectionTableViewControllerDelegate <NSObject>

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didSelectCondition:(SBCondition *)condition;
-(void)viewController:(SBAlgosSelectionTableViewController *)vc didViewCondition:(SBCondition *)condition;

@end

@interface SBAlgosSelectionTableViewController : UITableViewController

@property (nonatomic, weak) NSObject<SBAlgosSelectionTableViewControllerDelegate> *delegate;


@end
