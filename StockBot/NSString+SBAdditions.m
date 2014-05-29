//
//  NSString+SBAdditions.m
//  StockBot
//
//  Created by Robert Guo on 5/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "NSString+SBAdditions.h"

@implementation NSString (SBAdditions)

+(NSString *)randomStringOfLength:(NSInteger)length
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:length+1];
    for (NSUInteger i = 0U; i < length; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return [NSString stringWithString:s];
}


@end
