//
//  SBAlgorithmsManager.m
//  StockBot
//
//  Created by Robert Guo on 3/19/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgorithmsManager.h"

@interface SBAlgorithmsManager()

@end

@implementation SBAlgorithmsManager

+ (id)sharedManager {
    static SBAlgorithmsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
