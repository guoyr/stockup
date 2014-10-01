//
//  SBAlgosViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBStock;
@class SBAlgorithm;

@interface SBAlgosViewController : UIViewController

@property (nonatomic, strong) SBAlgorithm *curAlgo;
@property (nonatomic, strong) SBStock *curStock;

@end
