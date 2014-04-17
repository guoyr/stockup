//
//  SBAlgosViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgosViewController.h"
#import "SBConstants.h"
#import "SBAlgosDetailViewController.h"
#import "SBAlgosSelectionTableViewController.h"
#import "SBStock.h"
#import "SBStocksDataManager.h"

@interface SBAlgosViewController () <SBAlgosListTableViewControllerDelegate>

@property (nonatomic, strong) SBAlgosDetailViewController *dvc;
@property (nonatomic, strong) SBAlgosSelectionTableViewController *lvc;

@property (nonatomic, assign) CGRect bottomFrame;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect rightFrame;

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *sellButton;

@property (nonatomic, strong) UITextView *instructionView;

@end

@implementation SBAlgosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dvc = [[SBAlgosDetailViewController alloc] initWithNibName:nil bundle:nil];
        self.lvc = [[SBAlgosSelectionTableViewController alloc] initWithNibName:nil bundle:nil];
        [_lvc setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *stockName = [[SBStocksDataManager sharedManager]selectedStock].name;

    self.view.backgroundColor = BLACK;
    
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    int navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;
    int frameHeight = self.view.frame.size.height;
    int frameWidth = self.view.frame.size.width;
    
    _bottomFrame = CGRectMake(ALGO_LIST_WIDTH, frameHeight - BUY_BUTTON_HEIGHT -SELL_BUTTON_HEIGHT - navBarHeight, frameWidth - ALGO_LIST_WIDTH, BUY_BUTTON_HEIGHT+SELL_BUTTON_HEIGHT);
    _leftFrame = CGRectMake(0, 0, ALGO_LIST_WIDTH, frameHeight);
    _rightFrame = CGRectMake(ALGO_LIST_WIDTH, 0, frameWidth - ALGO_LIST_WIDTH, frameHeight - BUY_BUTTON_HEIGHT-SELL_BUTTON_HEIGHT);
    // Do any additional setup after loading the view.
    
    [self setTitle:[NSString stringWithFormat:@"%@股票的算法",stockName]];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    [self addChildViewController:_lvc];
    [_lvc.view setFrame:_leftFrame];
    [_lvc didMoveToParentViewController:self];
    
    [self.view addSubview:_lvc.view];
    
    CGRect buttonFrame = _bottomFrame;
    buttonFrame.size.height = BUY_BUTTON_HEIGHT;
    self.buyButton = [[UIButton alloc] initWithFrame:buttonFrame];
    buttonFrame.origin.y += BUY_BUTTON_HEIGHT;
    self.sellButton = [[UIButton alloc] initWithFrame:buttonFrame];
    
    [self.buyButton setTitle:@"买入" forState:UIControlStateNormal];
    [self.buyButton setBackgroundColor:BLUE_2];
    
    [self.sellButton setTitle:@"卖出" forState:UIControlStateNormal];
    [self.sellButton setBackgroundColor:BLUE_2];
    
    [self.buyButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buyButton addTarget:self action:@selector(sellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    self.instructionView = [[UITextView alloc] initWithFrame:CGRectMake(420, 200, 300, 500)];
    [self.instructionView setBackgroundColor:[UIColor blackColor]];
    [self.instructionView setFont:[UIFont systemFontOfSize:32]];
    [self.instructionView setText:[NSString stringWithFormat:@"请再作则选择您购买“%@”的条件。但该股票满足这些条件时，我们会为您进行交易",stockName]];
    [self.instructionView setTextColor:[UIColor whiteColor]];
    [self.instructionView setScrollEnabled:NO];
    [self.instructionView setEditable:NO];
    [self.instructionView setSelectable:NO];
    [self.view addSubview:self.instructionView];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SBAlgosListTableViewControllerDelegate

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didViewAlgorithm:(NSString *)algorithm
{
    if (!_dvc.view.superview) {
        [self.instructionView removeFromSuperview];
        [self addChildViewController:_dvc];
        [_dvc.view setFrame:_rightFrame];
        [_dvc didMoveToParentViewController:self];
        [self.view addSubview:_dvc.view];
        [self.view addSubview:self.buyButton];
        [self.view addSubview:self.sellButton];

    } else {
        //dvc already shown
    }
    
}

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didSelectAlgorithm:(NSString *)algorithm
{
    if (!_dvc.view.superview) {
        [self viewController:vc didViewAlgorithm:algorithm];
    }
    [_dvc addCondition:algorithm];

}

-(void)buyButtonPressed:(UIButton *)sender
{

}

-(void)sellButtonPressed:(UIButton *)sender
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
