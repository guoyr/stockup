//
//  SBAlgorithmsManager.h
//  StockBot
//
//  Created by Robert Guo on 3/19/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBAlgoTableViewCell;

@interface SBAlgorithmsManager : NSObject

+ (id)sharedManager;
-(void)setupMACDCell:(SBAlgoTableViewCell *)cell;
-(void)setupPriceCell:(SBAlgoTableViewCell *)cell;
@end
