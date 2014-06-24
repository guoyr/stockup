//
//  SBNavigationControllerDelegate.m
//  StockBot
//
//  Created by Robert Guo on 6/3/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBNavigationControllerDelegate.h"
#import "SBLoginAnimatedTransitioning.h"
#import "SBLoginViewController.h"

@implementation SBNavigationControllerDelegate

+ (id)sharedDelegate {
    static SBNavigationControllerDelegate *sharedDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegate = [self new];
    });
    return sharedDelegate;
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    if ([fromVC isKindOfClass:[SBLoginViewController class]]) {
        SBLoginAnimatedTransitioning *delegate = [SBLoginAnimatedTransitioning new];
        switch (operation) {
            case UINavigationControllerOperationPush:
                delegate.reverse = NO;
                return delegate;
                
            case UINavigationControllerOperationPop:
                delegate.reverse = YES;
                return delegate;
            default:
                return nil;
        }
    }
    return nil;

}

@end
