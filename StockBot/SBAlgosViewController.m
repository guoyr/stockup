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
#import "SBAlgosListTableViewController.h"

#define LIST_WIDTH 384
#define BUY_BUTTON_HEIGHT 48
#define SELL_BUTTON_HEIGHT 48

@interface SBAlgosViewController ()

@property (nonatomic, strong) SBAlgosDetailViewController *dvc;
@property (nonatomic, strong) SBAlgosListTableViewController *lvc;

@property (nonatomic, assign) CGRect bottomFrame;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect rightFrame;
@end

@implementation SBAlgosViewController

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
    self.view.backgroundColor = BLUE_4;
    self.dvc = [[SBAlgosDetailViewController alloc] initWithNibName:nil bundle:nil];
    self.lvc = [[SBAlgosListTableViewController alloc] initWithNibName:nil bundle:nil];
    
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    int navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;
    int frameHeight = self.view.frame.size.height;
    int frameWidth = self.view.frame.size.width;
    
    _bottomFrame = CGRectMake(LIST_WIDTH, frameHeight - BUY_BUTTON_HEIGHT -SELL_BUTTON_HEIGHT - navBarHeight, frameWidth - LIST_WIDTH, BUY_BUTTON_HEIGHT+SELL_BUTTON_HEIGHT);
    _leftFrame = CGRectMake(0, 0, LIST_WIDTH, frameHeight);
    _rightFrame = CGRectMake(LIST_WIDTH, 0, frameWidth - LIST_WIDTH, frameHeight - BUY_BUTTON_HEIGHT-SELL_BUTTON_HEIGHT - navBarHeight);
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    [self addChildViewController:_dvc];
    [_dvc.view setFrame:_rightFrame];
    [_dvc didMoveToParentViewController:self];
    
    [self addChildViewController:_lvc];
    [_lvc.view setFrame:_leftFrame];
    [_lvc didMoveToParentViewController:self];
    
    [self.view addSubview:_dvc.view];
    [self.view addSubview:_lvc.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
