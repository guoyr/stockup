//
//  SBSegmentedControl.h
//  StockBot
//
//  Created by Robert Guo on 6/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBSegmentedControl : UISegmentedControl

@property (nonatomic, assign) BOOL isExpanded;

-(void)shrink;
-(void)expand;

@end
