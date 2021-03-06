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
#import "SBDataManager.h"
#import "SBAlgoConfirmationViewController.h"
#import "SBCondition.h"

@interface SBAlgosViewController () <SBAlgosSelectionTableViewControllerDelegate>

@property (nonatomic, strong) SBAlgosDetailViewController *dvc;
@property (nonatomic, strong) SBAlgosSelectionTableViewController *lvc;

@property (nonatomic, assign) CGRect bottomFrame;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect rightFrame;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UITextView *instructionView;


@end

@implementation SBAlgosViewController


-(SBAlgosSelectionTableViewController *)lvc
{
    if (!_lvc) {
        _lvc = [[SBAlgosSelectionTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _lvc.delegate = self;
    }
    return _lvc;
}

-(SBAlgosDetailViewController *)dvc
{
    if (!_dvc) {
        _dvc = [[SBAlgosDetailViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _dvc;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.lvc.curAlgo = self.curAlgo;
    self.dvc.curAlgo = self.curAlgo;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *stockName = self.curStock.name;
    if (!stockName) {
        stockName = @"股红测试";
    }
    self.view.backgroundColor = BLACK_BG;
    
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    int navBarHeight = (int) (navBarFrame.origin.y + navBarFrame.size.height);
    int frameHeight = (int) self.view.frame.size.height;
    int frameWidth = (int) self.view.frame.size.width;
    
    _bottomFrame = CGRectMake(ALGO_LIST_WIDTH, frameHeight - CONFIRM_BUTTON_HEIGHT - navBarHeight, frameWidth - ALGO_LIST_WIDTH, CONFIRM_BUTTON_HEIGHT);
    _leftFrame = CGRectMake(0, 0, ALGO_LIST_WIDTH, frameHeight);
    _rightFrame = CGRectMake(ALGO_LIST_WIDTH, 0, frameWidth - ALGO_LIST_WIDTH, frameHeight - CONFIRM_BUTTON_HEIGHT - navBarHeight);
    // Do any additional setup after loading the view.
    
    [self setTitle:[NSString stringWithFormat:@"\"%@\"股票的算法",stockName]];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self.lvc.view setFrame:_leftFrame];

    [self addChildViewController:self.lvc];
    [self.lvc didMoveToParentViewController:self];
    [self.view addSubview:self.lvc.view];
    
    

    self.instructionView = [[UITextView alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH + 40, 120, 768-ALGO_LIST_WIDTH - 80, 480)];
    [self.instructionView setBackgroundColor:BLACK_BG];
    [self.instructionView setFont:[UIFont systemFontOfSize:32]];
    [self.instructionView setTextAlignment:NSTextAlignmentJustified];
    [self.instructionView setText:[NSString stringWithFormat:@"请在左侧选择您购买“%@”的条件。但该股票满足这些条件时，我们会为您进行交易",stockName]];
    [self.instructionView setTextColor:GREY_LIGHT];
    [self.instructionView setScrollEnabled:NO];
    [self.instructionView setEditable:NO];
    [self.instructionView setSelectable:NO];
    [self.view addSubview:self.instructionView];
    
    self.confirmButton = [[UIButton alloc] initWithFrame:_bottomFrame];
    [self.confirmButton setTitle:@"确认算法" forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:GREY_LIGHT   ];
    [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    self.confirmButton.enabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SBAlgosListTableViewControllerDelegate

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didRemoveCondition:(SBCondition *)condition
{
    [self viewController:vc didViewCondition:condition];
    [self.dvc removeCondition:condition];
    //self.confirmButton.enabled = NO;
}

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didViewCondition:(SBCondition *)condition
{
    if (!self.dvc.view.superview) {
        [self.instructionView removeFromSuperview];
        [self addChildViewController:self.dvc];
        [self.dvc.view setFrame:_rightFrame];
        [self.dvc didMoveToParentViewController:self];
        [self.view addSubview:self.dvc.view];
    } else {
        // dvc already shown
    }
    
    [self.dvc viewCondition:condition];
}

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didAddCondition:(SBCondition *)condition
{
    // have to have viewed the algorithm before selecting it
    [self viewController:vc didViewCondition:condition];
    [self.dvc addCondition:condition];
    self.confirmButton.enabled = YES;
    
}

-(void)viewController:(SBAlgosSelectionTableViewController *)vc didModifyCondition:(SBCondition *)condition
{
    [self viewController:vc didViewCondition:condition];
    [self.dvc modifyCondition:condition];
    
}


-(void)confirmButtonPressed:(UIButton *)sender
{
    NSLog(@"confirm button pressed");

    SBAlgoConfirmationViewController *tvc = [[SBAlgoConfirmationViewController alloc] initWithNibName:nil bundle:nil];
    tvc.curAlgo = self.curAlgo;
    [self.navigationController pushViewController:tvc animated:YES];

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
