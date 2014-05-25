//
//  SBTransactionViewController.m
//  StockBot
//
//  Created by Robert Guo on 3/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//
// shows details of the recently completed transaction

#import "SBAlgoConfirmationViewController.h"

@interface SBAlgoConfirmationViewController ()

@property (nonatomic, strong) SBCondition *curAlgorithm;
@property (nonatomic, strong) UITextField *algoNameTextField;
@property (nonatomic, strong) UILabel *descriptionLabel;

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
    
    self.algoNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(324, 40, 120, 48)];
    self.algoNameTextField.backgroundColor = YELLOW;
    [self.algoNameTextField becomeFirstResponder];
    [self.view addSubview:self.algoNameTextField];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(192, 106, 384, 428)];
    self.descriptionLabel.backgroundColor = YELLOW;
    [self.view addSubview:self.descriptionLabel];
    
    UILabel *namePrompt = [[UILabel alloc] initWithFrame:CGRectMake(324, 20, 60, 48)];
    namePrompt.backgroundColor = YELLOW;
    [self.view addSubview:namePrompt];
}

-(void)textFieldChanged
{
    
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
