//
//  SBAlgosDetailViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "SBAlgosDetailViewController.h"
#import "SBConstants.h"
#import "SBStocksDataManager.h"
#import "SBStock.h"
#import "SBStockGraphView.h"

@interface SBAlgosDetailViewController ()

@property (nonatomic, strong) SBStockGraphView *stockGraphView;
@property (nonatomic, strong) UITextView *algoSummaryView;
@property (nonatomic, strong) NSMutableArray *currentConditions;

@end

@implementation SBAlgosDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentConditions = [[NSMutableArray  alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:BLACK];
    // Do any additional setup after loading the view.

    self.stockGraphView = [[SBStockGraphView alloc] initWithFrame:CGRectMake(20, 20, 320, 240)];
    [self.view addSubview:self.stockGraphView];
    
    SBStock *stock = [[SBStocksDataManager sharedManager] selectedStock];
    NSURL *imageURL = [[SBStocksDataManager sharedManager] getKChartImageURLForStock:stock];
    [self.stockGraphView setImageWithURL:imageURL placeholderImage:nil];
    
    self.algoSummaryView = [[UITextView alloc] initWithFrame:CGRectMake(20, 320, 320, 640)];
    [self.algoSummaryView setBackgroundColor:BLACK];
    [self.algoSummaryView setFont:[UIFont systemFontOfSize:24]];
    [self.algoSummaryView setTextColor:WHITE];
    [self.algoSummaryView setScrollEnabled:NO];
    [self.algoSummaryView setEditable:NO];
    [self.algoSummaryView setSelectable:NO];
    [self.view addSubview:self.algoSummaryView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addCondition:(NSString *)condition
{
    NSLog(@"condition: %@",condition);
    if ([condition isEqualToString:@"MACD"]) {
        if ([self.currentConditions containsObject:condition]) {
            //remove MACD
            [self.currentConditions removeObject:condition];
            self.algoSummaryView.text = @"";
        } else {
            //add MACD
            self.algoSummaryView.text = @"您选择在MACD相交时对该股票进行操作";
            [self.currentConditions addObject:condition];
        }
    } else {
        if ([self.currentConditions containsObject:@"MACD"]) {
            // add price with existing MACD
            if ([self.currentConditions containsObject:condition]) {
                self.algoSummaryView.text = @"您选择在MACD相交时对该股票进行操作";
                [self.currentConditions removeObject:condition];
            } else {
                self.algoSummaryView.text = @"您选择在MACD相交，并且股价大于20元时时对该股票进行交易";
                [self.currentConditions addObject:condition];
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
