//
//  UIView+SBAdditions.m
//  StockBot
//
//  Created by Robert Guo on 6/3/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "UIView+SBAdditions.h"

@implementation UIView (SBAdditions)

-(void)scaleFrame:(double)scale
{
    CGPoint center = self.center;
    CGRect frame = self.frame;
    frame.size.width *= scale;
    frame.size.height *= scale;
    self.frame = frame;
    self.center = center;
}

-(void)moveFrameX:(NSInteger)distance
{
    CGPoint center = self.center;
    center.x += distance;
    self.center = center;
}

-(void)moveFrameY:(NSInteger)distance
{
    CGPoint center = self.center;
    center.y += distance;
    self.center = center;
}

@end
