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
#import "SBDataManager.h"
#import "SBStock.h"
#import "SBStockGraphView.h"
#import "SBAlgorithmManager.h"

@interface SBAlgosDetailViewController ()

@property (nonatomic, strong) SBStockGraphView *stockGraphView;
@property (nonatomic, strong) UITextView *algoSummaryView;
@property (nonatomic, strong) UITextView *conditionDescriptionView;
@property (nonatomic, strong) NSMutableArray *currentConditions;
@property (nonatomic, strong) UIView *conditionSummaryView;
@property (nonatomic, strong) SBAlgorithmManager *curAlgorithm;

@end

@implementation SBAlgosDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentConditions = [NSMutableArray new];
    }
    return self;        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:BLACK_BG];

    float detailViewWidth = 768 - ALGO_LIST_WIDTH;
    
    self.stockGraphView = [[SBStockGraphView alloc] initWithFrame:CGRectMake(10, 20, detailViewWidth - 20, 240)];
    [self.view addSubview:self.stockGraphView];
    self.stockGraphView.hidden = YES;
    
//    SBStock *stock = [[SBDataManager sharedManager] selectedStock];
//    NSURL *imageURL = [[SBDataManager sharedManager] getKChartImageURLForStock:stock];
//    [self.stockGraphView setImageWithURL:imageURL placeholderImage:nil];
    
    self.algoSummaryView = [[UITextView alloc] initWithFrame:CGRectMake(10, 432, detailViewWidth - 20, 420)];
    [self setupTextView:self.algoSummaryView];
    self.algoSummaryView.text = @"test";
    
    self.conditionDescriptionView = [[UITextView alloc] initWithFrame:CGRectMake(10, 268, detailViewWidth - 20, 160)];
    [self setupTextView:self.conditionDescriptionView];
    
    [self.view addSubview:self.algoSummaryView];
    [self.view addSubview:self.conditionDescriptionView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.curAlgorithm = [[SBDataManager sharedManager] selectedAlgorithm];
}

-(void)setupTextView:(UITextView *)textView
{
    [textView setBackgroundColor:BLACK_BG];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [textView setTextColor:WHITE];
//    [textView setScrollEnabled:NO];
    [textView setEditable:NO];
    [textView setSelectable:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewCondition:(SBCondition *)condition
{
    self.conditionDescriptionView.text = condition.conditionExplanation;
    self.stockGraphView.hidden = NO;
    self.stockGraphView.backgroundColor = WHITE;
}

-(void)removeCondition:(SBCondition *)condition
{
    [self.curAlgorithm.addedConditions removeObject:condition];
    [self updateAlgorithmDescription];
}

-(void)addCondition:(SBCondition *)condition
{
    [self.curAlgorithm.addedConditions addObject:condition];
    [self updateAlgorithmDescription];

}

-(void)modifyCondition:(SBCondition *)condition
{
    
    if ([self.curAlgorithm.addedConditions containsObject:condition]) {
        [self updateAlgorithmDescription];
    }
}


-(void)updateAlgorithmDescription
{
    // update the algorithm description when a condition has been added/removed/modified
    NSMutableString *description = [NSMutableString stringWithString:@"您选择在满足以下所有条件时购买该股票\n\n"];
    int counter = 1;
    for (SBCondition *condition in self.curAlgorithm.addedConditions) {
        NSString *ed = [condition extendedDescription];
        if (ed) {
            // user has selected criterias
            NSString *d = [NSString stringWithFormat:@"%d. %@",counter, ed];
            [description appendFormat:@"%@\n", d];
        } else {
            // user has not selected options for this condition
        }
        counter++;
    }
    self.algoSummaryView.text = [NSString stringWithString:description];
}

@end
