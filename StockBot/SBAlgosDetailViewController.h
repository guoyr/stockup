//
//  SBAlgosDetailViewController.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBCondition;
@class SBAlgorithm;

@interface SBAlgosDetailViewController : UIViewController

@property (nonatomic, strong) SBAlgorithm *curAlgo;


-(void)addCondition:(SBCondition *)condition;
-(void)viewCondition: (SBCondition *)condition;
-(void)removeCondition: (SBCondition *)condition;
-(void)modifyCondition: (SBCondition *)condition;
@end
