//
//  SBSegmentedControl.m
//  StockBot
//
//  Created by Robert Guo on 6/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBSegmentedControl.h"

@interface SBSegmentedControl()

@property (nonatomic, strong) NSMutableDictionary *hiddenControls;


@end

@implementation SBSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [self setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
        
        self.hiddenControls = [[NSMutableDictionary alloc] initWithCapacity:2];
//        self.isExpanded = YES;
    }
    return self;
}


-(void)expand
{
    if (!self.hiddenControls) {
        return;
    }
    
    if (self.hiddenControls.count > 0) {
        for (NSNumber *index in self.hiddenControls.allKeys) {
            NSInteger intIndex = [index intValue];
//            [self insertSegmentWithTitle:self.hiddenControls[index] atIndex:intIndex animated:NO];
        }
    }
    
    [self.hiddenControls removeAllObjects];
//    self.isExpanded = YES;
}

-(void)shrink;
{
    if (self.hiddenControls.count > 0) {
        return;
    }
    
    NSInteger segment = self.numberOfSegments - 1;
    
    while (segment >= 0) {
        if (segment != self.selectedSegmentIndex) {
            [self.hiddenControls setObject:[self titleForSegmentAtIndex:segment] forKey:[NSNumber numberWithInteger:segment]];
        }
        segment--;
    }
    
//    [self setSelectedSegmentIndex:-1];
    
//    self.isExpanded = NO;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
