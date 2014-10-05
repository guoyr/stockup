//
//  SBMandatoryCondition.m
//  StockBot
//
//  Created by Robert Guo on 7/5/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBMandatoryCondition.h"

@implementation SBMandatoryCondition

+(SBCondition *)conditionFromString:(NSString *) conditionString {
    return nil;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setupSegmentedControl];
    }
    return self;
}

-(void)setupSegmentedControl
{
    
}

-(NSDictionary *)archiveToDict
{
    return nil;
}

-(NSString *)archiveToString
{
    return nil;
}


@end
