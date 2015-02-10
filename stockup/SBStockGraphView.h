//
//  SBStockGraphView.h
//  StockBot
//
//  Created by Robert Guo on 3/19/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBStockGraphView : UIImageView

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
