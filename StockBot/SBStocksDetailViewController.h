//
//  SBStocksDetailViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBStock;
@interface SBStocksDetailViewController : UIViewController

-(void)showStock:(SBStock *)stock;

@end
