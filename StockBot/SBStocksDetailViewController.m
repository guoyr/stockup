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

@interface SBStocksDetailViewController ()

@property (nonatomic, strong) UIImageView *kChartView;
@property (nonatomic, strong) UIImageView *macdView;

@property (nonatomic, strong) SBStock *stock;
@property (nonatomic, strong) UIActivityIndicatorView *iv;
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
    
    self.iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.iv.hidesWhenStopped = YES;
    
    self.kChartView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 400, 280)];
    self.kChartView.backgroundColor = [UIColor darkGrayColor];
    [self.kChartView addSubview:self.iv];
    [self.iv setCenter:CGPointMake(self.kChartView.frame.size.width/2, self.kChartView.frame.size.height/2)];
    
    self.macdView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 400, 280)];
    self.macdView.backgroundColor = [UIColor darkGrayColor];
    
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
    [self.iv startAnimating];
    __block typeof(self) weakSelf = self;
    [self.kChartView setImageWithURL:kChartImageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        NSLog(@"done getting image");
        [weakSelf.iv stopAnimating];
        [weakSelf.kChartView setBackgroundColor:[UIColor  whiteColor]];
    }];
    [self.macdView setImageWithURL:macdImageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [weakSelf.macdView setBackgroundColor:[UIColor  whiteColor]];
    }];
    
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
