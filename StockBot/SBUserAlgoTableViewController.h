//
//  SBUserAlgoTableViewController.h
//  StockBot
//
//  Created by Robert Guo on 4/17/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBInstructionsViewController.h"
#import "SBTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface SBUserAlgoTableViewController : SBTableViewController <UIAlertViewDelegate, SBInstructionViewControllerDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@end
