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
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        self.name = [dataStringArray[0] componentsSeparatedByString:@"=\""][1];
        
        self.todayOpeningPrice = [numberFormatter numberFromString:dataStringArray[2]];
        self.yesterdayClosingPrice = [numberFormatter numberFromString:dataStringArray[3]];
        self.currentPrice = [numberFormatter numberFromString:dataStringArray[4]];
        self.todayHigh = [numberFormatter numberFromString:dataStringArray[5]];
        self.todayLow = [numberFormatter numberFromString:dataStringArray[6]];
        self.buyPrice = [numberFormatter numberFromString:dataStringArray[7]];
        self.sellPrice = [numberFormatter numberFromString:dataStringArray[8]];
        self.volume = [numberFormatter numberFromString:dataStringArray[9]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.fetchDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",dataStringArray[30],dataStringArray[31]]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        ;
    }

}

@end
