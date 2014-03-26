//
//  SBStocksDetailViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "SBStocksDetailViewController.h"
#import "SBConstants.h"
#import "SBStock.h"
#import "SBStocksDataManager.h"
#import "SBStockGraphView.h"

@interface SBStocksDetailViewController ()

@property (nonatomic, strong) SBStockGraphView *kChartView;
@property (nonatomic, strong) SBStockGraphView *macdView;

@property (nonatomic, strong) SBStock *stock;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *todayOpeningPriceLabel;
@property (nonatomic, strong) UILabel *yesterdayClosingPriceLabel;
@property (nonatomic, strong) UILabel *todayHighLabel;
@property (nonatomic, strong) UILabel *todayLowLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UILabel *buyPriceLabel;
@property (nonatomic, strong) UILabel *sellPriceLabel;
@property (nonatomic, strong) UILabel *volumeLabel;

@property (nonatomic, assign) NSInteger labelHeight;
@property (nonatomic, assign) NSInteger labelWidth;

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
    NSString *infoURL = [[SBStocksDataManager sharedManager] getStockInfoURLStringForStock:stock];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // default serializer doesn't suppor this content type
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:infoURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [stock updateInfoFromSinaData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetching stock information failed %@", error);
    }];

    [self.kChartView setImageWithURL:kChartImageURL placeholderImage:nil];
    [self.macdView setImageWithURL:macdImageURL placeholderImage:nil];
}

#pragma mark Private Methods

-(void)formatLabel:(UILabel *)label
{
    
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
