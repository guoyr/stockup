//
//  SBAlgorithmsManager.m
//  StockBot
//
//  Created by Robert Guo on 3/19/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgorithmsManager.h"
#import "SBAlgouCustomizeTableViewCell.h"
#import "SBConstants.h"

@interface SBAlgorithmsManager()

@end

@implementation SBAlgorithmsManager

+ (id)sharedManager {
    static SBAlgorithmsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)setupMACDCell:(SBAlgouCustomizeTableViewCell *)cell
{
//    NSLog(@"setupMACDCell");
//    cell.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 40)];
//    NSString *htmlString = @"MACD <u>正交</u>";
//    NSAttributedString *desc = [[NSAttributedString alloc] initWithData:(NSData *)[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}  documentAttributes:nil error:nil];
//    cell.descriptionLabel.attributedText = desc;
//    cell.descriptionLabel.font = [UIFont systemFontOfSize:24];
//    cell.descriptionLabel.textColor = WHITE;
//    
////    UILabel *macdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 60)];
////    macdLabel.text = @"MACD:";
////    macdLabel.font = [UIFont systemFontOfSize:22];
////    macdLabel.textColor = WHITE;
//    //    [cell.detailView addSubview:macdLabel];
//
//    UISegmentedControl *macdControl = [[UISegmentedControl alloc] initWithItems:@[@"正交", @"反交"]];
//    [macdControl setFrame:CGRectMake(80, 25, 200, 40)];
//    [macdControl setTintColor:WHITE];
//    [macdControl setSelectedSegmentIndex:0];
//    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
//    [macdControl setTitleTextAttributes:@{NSFontAttributeName:font} forState:UIControlStateNormal];
    
}

-(void)setupPriceCell:(SBAlgouCustomizeTableViewCell *)cell
{
//    NSLog(@"setupPriceCell");
//    if (![cell.descriptionLabel superview]) {
//        // no superview
//        cell.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 240, 40)];
//    } else {
//        cell.descriptionLabel.frame = CGRectMake(30, 30, 240, 40);
//    }
//    NSString *htmlString = @"价格 <u>大于</u> <u>20元</u>";
//    NSAttributedString *desc = [[NSAttributedString alloc] initWithData:(NSData *)[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                                                                                NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}  documentAttributes:nil error:nil];
//    cell.descriptionLabel.attributedText = desc;
//    cell.descriptionLabel.font = [UIFont systemFontOfSize:24];
//    cell.descriptionLabel.textColor = WHITE;
//    
//    UISegmentedControl *trendControl = [[UISegmentedControl alloc] initWithItems:@[@"大于", @"小于"]];
//    [trendControl setFrame:CGRectMake(80, 25, 200, 40)];
//    [trendControl setTintColor:WHITE];
//    [trendControl setSelectedSegmentIndex:0];
//    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
//    [trendControl setTitleTextAttributes:@{NSFontAttributeName:font} forState:UIControlStateNormal];
    
}

@end
