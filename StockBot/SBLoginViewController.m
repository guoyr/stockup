//
//  SBLoginViewController.m
//  StockBot
//
//  Created by Robert Guo on 4/16/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBLoginViewController.h"
#import "SBConstants.h"
#import "SBUserAlgoTableViewController.h"
#import "SBBrokersTableViewController.h"
#import "SBDataManager.h"

@interface SBLoginViewController ()

@property (nonatomic, strong) UIButton *brokerSelectionButton;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIPopoverController *brokerListPopover;
@property (nonatomic, strong) NSString *selectedBroker;

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
    
    self.brokerSelectionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.brokerSelectionButton setFrame:CGRectMake(320, 260, 128, 48)];
    [self.brokerSelectionButton setTitle:@"选择券商" forState:UIControlStateNormal];
    [self.brokerSelectionButton addTarget:self action:@selector(selectBroker:) forControlEvents:UIControlEventTouchUpInside];
    
    SBBrokersTableViewController *cvc = [[SBBrokersTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [cvc.tableView setDelegate:self];
    self.brokerListPopover = [[UIPopoverController alloc] initWithContentViewController:cvc];
    [self.brokerListPopover setPopoverContentSize:CGSizeMake(320, 240)];
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(320, 320, 128, 48)];
    self.usernameField.backgroundColor = WHITE;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(320, 380, 128, 48)];
    self.passwordField.backgroundColor = WHITE;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(340, 440, 88, 48)];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 320, 96, 48)];
    [usernameLabel setText:@"账号名"];
    [usernameLabel setTextColor:WHITE];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 380, 96, 48)];
    [passwordLabel setText:@"密码"];
    [passwordLabel setTextColor:WHITE];
    
    
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];

    [self.usernameField setDelegate:self];
    [self.passwordField setDelegate:self];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.brokerSelectionButton];
    [self.view addSubview:self.usernameField];
    
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.loginButton];
    
    [self.view addSubview:usernameLabel];
    [self.view addSubview:passwordLabel];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.brokerListPopover dismissPopoverAnimated:YES];
    self.selectedBroker = [[SBDataManager sharedManager] brokerList][indexPath.row];
}

-(void)selectBroker:(UIButton *)sender
{
    if ([self.brokerListPopover isPopoverVisible]) {
        [self.brokerListPopover dismissPopoverAnimated:YES];
    } else {
        [self.brokerListPopover presentPopoverFromRect:self.brokerSelectionButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)loginButtonClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedin"];
    [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:@"passoword"];
    SBUserAlgoTableViewController *avc = [[SBUserAlgoTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController setViewControllers:@[avc] animated:YES];
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
