//
//  SBLoginViewController.m
//  StockBot
//
//  Created by Robert Guo on 4/16/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBLoginViewController.h"
#import "SBConstants.h"

@interface SBLoginViewController ()

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation SBLoginViewController

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
    self.title = @"股票自动交易系统";
    self.view.backgroundColor = BLUE_4;
    // Do any additional setup after loading the view.
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(320, 320, 128, 48)];
    self.usernameField.backgroundColor = WHITE;
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(320, 380, 128, 48)];
    self.passwordField.backgroundColor = WHITE;
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(340, 440, 88, 48)];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 320, 96, 48)];
    [usernameLabel setText:@"用户名"];
    [usernameLabel setTextColor:WHITE];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 380, 96, 48)];
    [passwordLabel setText:@"密码"];
    [passwordLabel setTextColor:WHITE];
    
    
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];

    [self.usernameField setDelegate:self];
    [self.passwordField setDelegate:self];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:usernameLabel];
    [self.view addSubview:passwordLabel];
    
}

-(void)loginButtonClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedin"];
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
