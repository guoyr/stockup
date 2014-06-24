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
#import "SBDataManager.h"
#import "SBStockGraphView.h"

@interface SBStocksDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

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
@property (nonatomic, strong) UILabel *dateLabel;

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
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
    self.scrollView.frame = self.view.bounds;
    [self.scrollView setScrollEnabled:YES];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
//    [self.view.layer setBorderColor:[UIColor blueColor].CGColor];
//    [self.view.layer setBorderWidth:5.0f];
    
    self.kChartView = [[SBStockGraphView alloc] initWithFrame:CGRectMake(20, 20, 400, 280)];
    self.macdView = [[SBStockGraphView alloc] initWithFrame:CGRectMake(20, 320, 400, 280)];
    
    self.labelHeight = 620;
    self.labelWidth = 20;
    
    self.nameLabel = [self formatLabel:self.nameLabel];
    self.todayOpeningPriceLabel = [self formatLabel:self.todayOpeningPriceLabel];
    self.yesterdayClosingPriceLabel = [self formatLabel:self.yesterdayClosingPriceLabel];
    self.todayHighLabel = [self formatLabel:self.todayHighLabel];
    self.todayLowLabel = [self formatLabel:self.todayLowLabel];
    self.currentPriceLabel = [self formatLabel:self.currentPriceLabel];
    self.buyPriceLabel = [self formatLabel:self.buyPriceLabel];
    self.sellPriceLabel = [self formatLabel:self.sellPriceLabel];
    self.volumeLabel = [self formatLabel:self.volumeLabel];
    self.dateLabel = [self formatLabel:self.dateLabel];
    
    // hack to make the date show up entirely
    CGRect frame = self.dateLabel.frame;
    frame.origin.x = 20;
    frame.origin.y += 50;
    frame.size.width += 200;
    self.dateLabel.frame = frame;
    
    [self.scrollView addSubview:self.kChartView];
    [self.scrollView addSubview:self.macdView];
    
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showStock:(SBStock *)stock
{
    self.stock = stock;
    NSURL *kChartImageURL = [[SBDataManager sharedManager] getKChartImageURLForStock:stock];
    NSURL *macdImageURL = [[SBDataManager sharedManager] getMACDImageURLForStock:stock];
    NSString *infoURL = [[SBDataManager sharedManager] getStockInfoURLStringForStock:stock];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // default serializer doesn't suppor this content type
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.nameLabel setText:@"股票名称"];
    [self.todayOpeningPriceLabel setText:@"今日开盘价"];
    [self.yesterdayClosingPriceLabel setText:@"昨日开盘价"];
    [self.todayHighLabel setText:@"今日最高价"];
    [self.todayLowLabel setText:@"今日最低价"];
    [self.currentPriceLabel setText:@"当前价"];
    [self.buyPriceLabel setText:@"买入价"];
    [self.sellPriceLabel setText:@"卖出价"];
    [self.volumeLabel setText:@"成交量"];
    [self.dateLabel setText:@"数据日期"];
    
    [manager GET:infoURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [stock updateInfoFromSinaData:responseObject];
        [self.nameLabel setText:[NSString stringWithFormat:@"股票名称：%@",self.stock.name]];
        [self.todayOpeningPriceLabel setText:[NSString stringWithFormat:@"今日开盘价：￥%.3f",[stock.todayOpeningPrice floatValue]]];
        [self.yesterdayClosingPriceLabel setText:[NSString stringWithFormat:@"昨日开盘价：￥%.3f",[stock.yesterdayClosingPrice floatValue]]];
        [self.todayHighLabel setText:[NSString stringWithFormat:@"今日最高价：￥%.3f",[stock.todayHigh floatValue]]];
        [self.todayLowLabel setText:[NSString stringWithFormat:@"今日最低价：￥%.3f",[stock.todayLow floatValue]]];
        [self.currentPriceLabel setText:[NSString stringWithFormat:@"当前价：￥%.3f",[stock.currentPrice floatValue]]];
        [self.buyPriceLabel setText:[NSString stringWithFormat:@"买入价：￥%.3f",[stock.buyPrice floatValue]]];
        [self.sellPriceLabel setText:[NSString stringWithFormat:@"卖出价：￥%.3f",[stock.sellPrice floatValue]]];
        [self.volumeLabel setText:[NSString stringWithFormat:@"成交量：%d",[stock.volume intValue]]];
        [self.dateLabel setText:[NSString stringWithFormat:@"数据日期：%@",stock.fetchDate]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetching stock information failed %@", error);
    }];

    [self.kChartView setImageWithURL:kChartImageURL placeholderImage:nil];
    [self.macdView setImageWithURL:macdImageURL placeholderImage:nil];
}

#pragma mark Private Methods

-(UILabel *)formatLabel:(UILabel *)label
{
    int labelWidth = 220;
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.labelWidth, self.labelHeight, labelWidth, 40)];
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    if (self.labelWidth > 20) {
        self.labelWidth = 20;
        self.labelHeight += 50;
    } else {
        self.labelWidth = labelWidth + 20;
    }
    [self.scrollView addSubview:label];
    return label;
    
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
