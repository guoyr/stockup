//
//  SBTransactionViewController.h
//  StockBot
//
//  Confirm an user selected algorithmic transaction criteria
//
//  Created by Robert Guo on 3/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAlgorithm.h"

@class SBStock;


@interface SBAlgoConfirmationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) SBStock *stock;

@end
