//
//  SBLoginAnimatedTransitioning.m
//  StockBot
//
//  Created by Robert Guo on 6/3/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBLoginAnimatedTransitioning.h"
#import "SBLoginViewController.h"
#import "SBUserAlgoTableViewController.h"

static NSTimeInterval const SBAnimatedTransitionDuration = 0.5f;

@implementation SBLoginAnimatedTransitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    SBLoginViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SBUserAlgoTableViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.reverse) {
        [container addSubview:fromViewController.view];
    } else {
        [container addSubview:toViewController.view];
    }
    [transitionContext completeTransition:YES];
}

-(void)animationEnded:(BOOL)transitionCompleted
{
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return SBAnimatedTransitionDuration;
}

@end
