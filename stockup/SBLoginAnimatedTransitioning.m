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

static NSTimeInterval const SBAnimatedTransitionDuration = 1.5f;

@implementation SBLoginAnimatedTransitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *container = [transitionContext containerView];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    if (self.reverse) {
        SBUserAlgoTableViewController *fromVC = (SBUserAlgoTableViewController *)fromViewController;
        SBLoginViewController *toVC = (SBLoginViewController *)toViewController;
        [container addSubview:toVC.view];
        toVC.view.alpha = 0.0;
        [UIView animateWithDuration:SBAnimatedTransitionDuration animations:^{
            fromVC.view.alpha = 0.0f;
            toVC.view.alpha = 1.0f;
            toVC.inputBackground.transform = CGAffineTransformIdentity;
            toVC.logoImageView.transform = CGAffineTransformIdentity;
            toVC.loginButton.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
            NSLog(@"reverse");
        }];
    } else {
        SBLoginViewController *fromVC = (SBLoginViewController *)fromViewController;
        SBUserAlgoTableViewController *toVC = (SBUserAlgoTableViewController *)toViewController;
        [container addSubview:toVC.view];
        toVC.view.alpha = 0.0;
        [UIView animateWithDuration:SBAnimatedTransitionDuration  animations:^{
            fromVC.view.alpha = 0.0f;
            toVC.view.alpha = 1.0f;
            fromVC.logoImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(100.0f, 100.0f), 0, -100);
            fromVC.loginButton.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(100.0f, 100.0f), 0, 500);
            fromVC.inputBackground.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(100.0f, 100.0f), 0, 500);;
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
            NSLog(@"forward");
        }];

    }
}

-(void)animationEnded:(BOOL)transitionCompleted
{
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return SBAnimatedTransitionDuration;
}

@end
