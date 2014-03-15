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

#define LIST_WIDTH 320
#define CONFIRM_BUTTON_HEIGHT 48

@interface SBStocksViewController () <SBStocksListTableViewControllerDelegate>

@property (nonatomic, strong) SBStocksDetailViewController *dvc;
@property (nonatomic, strong) SBStocksListTableViewController *tvc;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect rightFrame;
@property (nonatomic, assign) CGRect bottomFrame;

@property (nonatomic, strong) UITextView *instructionView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) SBAlgosViewController *algoVC;
@end

@implementation SBStocksViewController

#pragma mark getters and setters

-(SBAlgosViewController *)algoVC{
    if (!_algoVC) {
        _algoVC = [[SBAlgosViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _algoVC;
}

#pragma mark viewcontroller methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setDvc:[[SBStocksDetailViewController alloc] initWithNibName:nil bundle:nil]];
        [self setTvc:[[SBStocksListTableViewController alloc] initWithStyle:UITableViewStylePlain]];
        [_tvc setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    int navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;
    int frameHeight = self.view.frame.size.height;
    int frameWidth = self.view.frame.size.width;
    
    _bottomFrame = CGRectMake(LIST_WIDTH, frameHeight - CONFIRM_BUTTON_HEIGHT - navBarHeight, frameWidth - LIST_WIDTH, CONFIRM_BUTTON_HEIGHT);
    _leftFrame = CGRectMake(0, 0, LIST_WIDTH, frameHeight);
    _rightFrame = CGRectMake(LIST_WIDTH, 0, frameWidth - LIST_WIDTH, frameHeight - CONFIRM_BUTTON_HEIGHT - navBarHeight);
    
//    NSLog(@"%@, %@, %@", NSStringFromCGRect(_leftFrame), NSStringFromCGRect(_rightFrame), NSStringFromCGRect(_bottomFrame));

    [self setTitle:@"炒股机器人"];
//    [[self navigationItem] setTitle:@"炒股机器人"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.confirmButton = [[UIButton alloc] initWithFrame:_bottomFrame];
    [self.confirmButton setTitle:@"购买该股票" forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:BLUE_2];
    [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addChildViewController:_tvc];
    [_tvc.view setFrame:_leftFrame];
    [_tvc didMoveToParentViewController:self];
    
    [self.view addSubview:_tvc.view];
    
    self.instructionView = [[UITextView alloc] initWithFrame:CGRectMake(400, 200, 300, 500)];
    [self.instructionView setBackgroundColor:[UIColor blackColor]];
    [self.instructionView setFont:[UIFont systemFontOfSize:32]];
    [self.instructionView setText:@"欢迎您使用股票买卖助手。请再左手栏里选择一只您想买卖的股票"];
    [self.instructionView setTextColor:[UIColor whiteColor]];
    [self.instructionView setScrollEnabled:NO];
    [self.view addSubview:self.instructionView];
}

-(void)confirmButtonPressed:(id)sender
{
    [self.navigationController pushViewController:self.algoVC animated:YES];
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
    if (!_dvc.view.superview) {
        [self addChildViewController:_dvc];
        [_dvc.view setFrame:_rightFrame];
        [_dvc didMoveToParentViewController:self];
        [self.view addSubview:_dvc.view];
    
        [self.view addSubview:self.confirmButton];
    } else {
        NSLog(@"dvc already shown");
    }
    [_dvc showStock:stock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
