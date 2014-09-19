//
//  SBStock.m
//  StockBot
//
//  Created by Robert Guo on 3/14/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBStock.h"

@implementation SBStock

-(void)setStockID:(NSNumber *)stockID
{
    _stockID = stockID;
    self.stockIDString = [NSString stringWithFormat:@"sh%d",[stockID intValue]];
}



@end
