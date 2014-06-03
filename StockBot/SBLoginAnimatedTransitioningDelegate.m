//
//  SBLoginAnimatedTransitioningDelegate.m
//  StockBot
//
//  Created by Robert Guo on 6/3/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBLoginAnimatedTransitioningDelegate.h"
#import "SBLoginAnimatedTransitioning.h"

@implementation SBLoginAnimatedTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [SBLoginAnimatedTransitioning new];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SBLoginAnimatedTransitioning *t = [SBLoginAnimatedTransitioning new];
    t.reverse = YES;
    return t;
}

@end
