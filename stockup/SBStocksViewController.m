//
//  SBStocksViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBStocksViewController.h"
#import "SBStocksDetailViewController.h"
#import "SBStocksListTableViewController.h"
#import "SBAlgosViewController.h"
#import "SBConstants.h"
#import "SBAlgosViewController.h"
#import "SBStock.h"
#import "SBDataManager.h"
#import "SBAlgorithm.h"

@interface SBStocksViewController () <SBStocksListTableViewControllerDelegate>

@property (nonatomic, strong) SBStocksDetailViewController *dvc;
@property (nonatomic, strong) SBStocksListTableViewController *tvc;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect rightFrame;
@property (nonatomic, assign) CGRect bottomFrame;

@property (nonatomic, strong) UITextView *instructionView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) SBStock *stock;
@property (nonatomic, strong) SBAlgosViewController *algosVC;

@end

@implementation SBStocksViewController

#pragma mark viewcontroller methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(SBStocksDetailViewController *)dvc
{
    if (!_dvc) {
        _dvc = [[SBStocksDetailViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _dvc;
}

-(SBStocksListTableViewController *)tvc
{
    if (!_tvc) {
        _tvc = [[SBStocksListTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [_tvc setDelegate:self];
    }
    return _tvc;
}

-(SBAlgosViewController *)algosVC
{
    if (!_algosVC) {
        _algosVC = [[SBAlgosViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _algosVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BLACK_BG;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    int navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;
    int frameHeight = self.view.frame.size.height;
    int frameWidth = self.view.frame.size.width;
    
    _bottomFrame = CGRectMake(STOCK_CELL_WIDTH, frameHeight - CONFIRM_BUTTON_HEIGHT - navBarHeight, frameWidth - STOCK_CELL_WIDTH, CONFIRM_BUTTON_HEIGHT);
    _leftFrame = CGRectMake(0, 0, STOCK_CELL_WIDTH, frameHeight);
    _rightFrame = CGRectMake(STOCK_CELL_WIDTH, 0, frameWidth - STOCK_CELL_WIDTH, frameHeight - CONFIRM_BUTTON_HEIGHT - navBarHeight);
    
    [self setTitle:@"选择股票"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.confirmButton = [[UIButton alloc] initWithFrame:_bottomFrame];
    [self.confirmButton setTitle:@"选择该股票" forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:GREY_LIGHT];
    [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tvc.view setFrame:_leftFrame];
    [self addChildViewController:self.tvc];
    [self.tvc didMoveToParentViewController:self];
    
    [self.view addSubview:self.tvc.view];
    
    self.instructionView = [[UITextView alloc] initWithFrame:CGRectMake(400, 200, 300, 500)];
    [self.instructionView setBackgroundColor:BLACK_BG];
    [self.instructionView setFont:[UIFont systemFontOfSize:32]];
    [self.instructionView setText:@"欢迎您使用股票买卖助手。请再左手栏里选择一只您想买卖的股票"];
    [self.instructionView setTextColor:WHITE];
    [self.instructionView setScrollEnabled:NO];
    [self.instructionView setEditable:NO];
    [self.instructionView setSelectable:NO];
    [self.view addSubview:self.instructionView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tvc.curAlgo = self.curAlgo;
}

-(void)confirmButtonPressed:(id)sender
{

    self.curAlgo.stockID = self.stock.stockID;
    self.algosVC.curAlgo = self.curAlgo;
    self.algosVC.curStock = self.stock;
    [self.navigationController pushViewController:self.algosVC animated:YES];
//    [self willMoveToParentViewController:nil];
//    [self.navigationController addChildViewController:self.algoVC];
//    [self.algoVC.view setFrame:self.bottomFrame];
//    
//    NSLog(@"%@",self.parentViewController);
//    NSLog(@"%@",self.algoVC.parentViewController);
//    
//    __weak __block SBStocksViewController *weakSelf = self;
//    [self transitionFromViewController:self toViewController:self.algoVC duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
//        [self.algoVC.view setFrame:self.view.bounds];
//    } completion:^(BOOL finished) {
//        [self.algoVC didMoveToParentViewController:self.navigationController];
//        [self removeFromParentViewController];
//    }];
}

#pragma mark SBStocksListTableViewControllerDelegate

-(void)viewController:(SBStocksListTableViewController *)vc didSelectStock:(SBStock *)stock
{
    if (!self.dvc.view.superview) {
        [self.instructionView removeFromSuperview];
        [self addChildViewController:self.dvc];
        [self.dvc.view setFrame:_rightFrame];
        [self.dvc didMoveToParentViewController:self];
        [self.view addSubview:self.dvc.view];
        [self.view addSubview:self.confirmButton];
    } else {
        //dvc already shown
    }
    
    self.stock = stock;
    [self.dvc showStock:stock];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
