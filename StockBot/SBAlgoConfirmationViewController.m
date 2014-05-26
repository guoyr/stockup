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

@interface SBAlgoConfirmationViewController ()

@property (nonatomic, strong) UITextField *algoNameTextField;
@property (nonatomic, strong) UITextView *descriptionLabel;

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
    [self.algoNameTextField becomeFirstResponder];
    [self.algoNameTextField setDelegate:self];
    [self.algoNameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.algoNameTextField];
    
    self.descriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(192, 116, 384, 428)];
    self.descriptionLabel.textColor = WHITE;
    self.descriptionLabel.backgroundColor = BLACK;
    [self.descriptionLabel setUserInteractionEnabled:NO];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:self.descriptionLabel];
    self.descriptionLabel.text = @"placeholder\nanother line";
    
    UILabel *namePrompt = [[UILabel alloc] initWithFrame:CGRectMake(324, 20, 60, 48)];
    namePrompt.backgroundColor = YELLOW;
    [self.view addSubview:namePrompt];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    
    self.curAlgorithm = [[SBDataManager sharedManager] selectedAlgorithm];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[SBDataManager sharedManager] saveAlgorithm:self.curAlgorithm];
    return YES;
}

-(void)done:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)textFieldChanged:(UITextField *)sender
{
    self.curAlgorithm.name = sender.text;
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
