//
//  SBAlgosListTableViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"
#import "SBCondition.h"

@class SBAlgosSelectionTableViewController;

@protocol SBAlgosSelectionTableViewControllerDelegate <NSObject>

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didAddCondition:(SBCondition *)condition;
-(void)viewController:(SBAlgosSelectionTableViewController *)vc didViewCondition:(SBCondition *)condition;
-(void)viewController:(SBAlgosSelectionTableViewController *)vc didRemoveCondition:(SBCondition *)condition;
-(void)viewController:(SBAlgosSelectionTableViewController *)vc didModifyCondition:(SBCondition *)condition;

@end

@interface SBAlgosSelectionTableViewController : SBTableViewController <SBConditionDelegate>

@property (nonatomic, weak) NSObject<SBAlgosSelectionTableViewControllerDelegate> *delegate;


@end
