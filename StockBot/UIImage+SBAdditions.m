//
//  UIImage+SBAdditions.m
//  StockBot
//
//  Created by Robert Guo on 6/24/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "UIImage+SBAdditions.h"

@implementation UIImage (SBAdditions)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
