//
//  UIView+SBAdditions.h
//  StockBot
//
//  Created by Robert Guo on 6/3/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SBAdditions)

-(void)scaleFrame:(double)scale;
-(void)moveFrameX:(NSInteger)distance;
-(void)moveFrameY:(NSInteger)distance;

@end
