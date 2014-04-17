//
//  SBStockGraphView.m
//  StockBot
//
//  Created by Robert Guo on 3/19/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//
#import <UIImageView+WebCache.h>
#import "SBStockGraphView.h"
#import "SBConstants.h"

@implementation SBStockGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.hidesWhenStopped = YES;
        NSLog(@"%@",NSStringFromCGPoint(self.center));
        [self.activityView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        self.layer.cornerRadius = 10.f;
    }
    return self;
}

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    __block typeof(self) weakSelf = self;
    self.backgroundColor = BLUE_4;
    [self.activityView startAnimating];
    [self setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        [weakSelf.activityView stopAnimating];
        weakSelf.backgroundColor = WHITE;
    }];
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
