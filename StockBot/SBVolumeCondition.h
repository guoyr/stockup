//
//  SBVolumeCondition.h
//  StockBot
//
//  Created by Robert Guo on 6/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBMandatoryCondition.h"

@interface SBVolumeCondition : SBMandatoryCondition

@property (nonatomic, assign) int volume;

@end
