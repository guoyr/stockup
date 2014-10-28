//
//  SBTransactionViewController.m
//  StockBot
//
//  Created by Robert Guo on 3/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//
// shows details of the recently completed transaction

#import "SBAlgoConfirmationViewController.h"
#import "SBAlgorithm.h"
#import "SBDataManager.h"
#import "SBStock.h"
#import "SBConstants.h"

@interface SBAlgoConfirmationViewController ()

@property (nonatomic, strong) UITextField *algoNameTextField;
@property (nonatomic, strong) UITextView *descriptionLabel;
@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;

@end

@implementation SBAlgoConfirmationViewController

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.algoNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(324, 60, 120, 48)];
    self.algoNameTextField.textColor = WHITE;
    [self.algoNameTextField setDelegate:self];
    [self.algoNameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.algoNameTextField];
    
    self.descriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(192, 116, 384, 428)];
    self.descriptionLabel.textColor = WHITE;
    self.descriptionLabel.backgroundColor = BLACK_BG;
    [self.descriptionLabel setUserInteractionEnabled:NO];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:self.descriptionLabel];
    self.descriptionLabel.text = @"这里显示算法简介";
    
    UILabel *namePrompt = [[UILabel alloc] initWithFrame:CGRectMake(324, 20, 120, 48)];
    namePrompt.textColor = WHITE;
    namePrompt.text = @"请输入算法名字";
    [self.view addSubview:namePrompt];

    self.view.backgroundColor = BLACK_BG;
    
    self.doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = self.doneButtonItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.title = @"保存算法";
    
    if (!self.curAlgo.name) {
        self.curAlgo.name = [[SBDataManager sharedManager] defaultAlgorithmName];
    }
    self.algoNameTextField.text = self.curAlgo.name;
    [self.algoNameTextField becomeFirstResponder];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)done:(UIBarButtonItem *)sender
{
    [[SBDataManager sharedManager] saveAlgorithm:self.curAlgo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)textFieldChanged:(UITextField *)sender
{
    self.curAlgo.name = sender.text;
    self.doneButtonItem.enabled = [sender.text length] != 0;
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
