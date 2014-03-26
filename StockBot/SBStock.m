//
//  SBStock.m
//  StockBot
//
//  Created by Robert Guo on 3/14/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBStock.h"

@implementation SBStock

-(void)updateInfoFromSinaData:(id)rawData
{
    
    @try {
        unsigned long encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *s = [[NSString alloc] initWithData:rawData encoding:encoding];
        NSArray *dataStringArray = [s componentsSeparatedByString:@","];
        
        self.name = [dataStringArray[0] componentsSeparatedByString:@"=\""][1];
        self.todayOpeningPrice = dataStringArray[1];
        self.yesterdayClosingPrice = dataStringArray[2];
        self.currentPrice = dataStringArray[3];
        self.todayHigh = dataStringArray[4];
        self.todayLow = dataStringArray[5];
        self.buyPrice = dataStringArray[6];
        self.sellPrice = dataStringArray[7];
        self.volume = dataStringArray[8];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        ;
    }

}

@end
