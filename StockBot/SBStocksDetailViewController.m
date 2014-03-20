//
//  SBStocksDetailViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIImageView+AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "SBStocksDetailViewController.h"
#import "SBConstants.h"
#import "SBStock.h"
#import "SBStocksDataManager.h"
#import "SBStockGraphView.h"

@interface SBStocksDetailViewController ()

@property (nonatomic, strong) SBStockGraphView *kChartView;
@property (nonatomic, strong) SBStockGraphView *macdView;

@property (nonatomic, strong) SBStock *stock;
@end

@implementation SBStocksDetailViewController
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
//    [self.view.layer setBorderColor:[UIColor blueColor].CGColor];
//    [self.view.layer setBorderWidth:5.0f];
    
    self.kChartView = [[SBStockGraphView alloc] initWithFrame:CGRectMake(20, 20, 400, 280)];

    self.macdView = [[SBStockGraphView alloc] initWithFrame:CGRectMake(20, 320, 400, 280)];
    
    [self.view addSubview:self.kChartView];
    [self.view addSubview:self.macdView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showStock:(SBStock *)stock
{
    self.stock = stock;
    NSURL *kChartImageURL = [[SBStocksDataManager sharedManager] getKChartImageURLForStock:stock];
    NSURL *macdImageURL = [[SBStocksDataManager sharedManager] getMACDImageURLForStock:stock];

    [self.kChartView setImageWithURL:kChartImageURL placeholderImage:nil];
    [self.macdView setImageWithURL:macdImageURL placeholderImage:nil];
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
