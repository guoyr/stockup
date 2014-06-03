//
//  SBLoginViewController.m
//  StockBot
//
//  Created by Robert Guo on 4/16/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SBLoginViewController.h"
#import "SBConstants.h"
#import "SBUserAlgoTableViewController.h"
#import "SBBrokersTableViewController.h"
#import "SBDataManager.h"

@interface SBLoginViewController ()


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
    self.title = @"股红";
    self.view.backgroundColor = BLUE_4;
    // Do any additional setup after loading the view.
    
    
    SBBrokersTableViewController *cvc = [[SBBrokersTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [cvc.tableView setDelegate:self];
    self.brokerListPopover = [[UIPopoverController alloc] initWithContentViewController:cvc];
    [self.brokerListPopover setPopoverContentSize:CGSizeMake(240, 240)];
    self.inputBackground.layer.cornerRadius = 10;
    
    [self.usernameField setDelegate:self];
    [self.passwordField setDelegate:self];
    
    [self.brokerSelectionButton addTarget:self action:@selector(selectBroker:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginButton.layer.borderColor = [GREEN_0 CGColor];
    self.brokerSelectionButton.layer.borderColor = [GREEN_0 CGColor];

    self.loginButton.layer.borderWidth = 1.0f;
    self.brokerSelectionButton.layer.borderWidth = 1.0f;
    
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.layer.cornerRadius = 5.0f;


    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
    
    
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect frame1 = self.logoImageView.frame;
    
    frame1.origin.y += keyboardFrame.size.height/4;
    CGRect frame2 = self.inputBackground.frame;
    frame2.origin.y += keyboardFrame.size.height/2;
    CGRect frame3 = self.loginButton.frame;
    frame3.origin.y += keyboardFrame.size.height/2 + 10;

    [UIView animateWithDuration:[animationDuration doubleValue] animations:^{
        self.logoImageView.frame = frame1;
        self.inputBackground.frame = frame2;
        self.loginButton.frame = frame3;
        
    }];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect frame1 = self.logoImageView.frame;
    
    frame1.origin.y -= keyboardFrame.size.height/4;
    CGRect frame2 = self.inputBackground.frame;
    frame2.origin.y -= keyboardFrame.size.height/2;
    CGRect frame3 = self.loginButton.frame;
    frame3.origin.y -= keyboardFrame.size.height/2 + 10;
    [UIView animateWithDuration:[animationDuration doubleValue] animations:^{
        self.logoImageView.frame = frame1;
        self.inputBackground.frame = frame2;
        self.loginButton.frame = frame3;

    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.brokerListPopover dismissPopoverAnimated:YES];
    self.selectedBroker = [[SBDataManager sharedManager] brokerList][indexPath.row];
    self.brokerSelectionButton.titleLabel.text = self.selectedBroker;
}

-(void)selectBroker:(UIButton *)sender
{
    if ([self.brokerListPopover isPopoverVisible]) {
        [self.brokerListPopover dismissPopoverAnimated:YES];
    } else {
        [self.brokerListPopover presentPopoverFromRect:self.brokerSelectionButton.frame inView:self.inputBackground permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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
