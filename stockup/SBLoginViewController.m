//
//  SBLoginViewController.m
//  StockBot
//
//  Created by Robert Guo on 4/16/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//
#import "SBLoginViewController.h"
#import "SBUserAlgoTableViewController.h"
#import "SBBrokersTableViewController.h"
#import "SBDataManager.h"
#import "SBNavigationControllerDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBConstants.h"

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
    NSLog(@"login view did load");
    [super viewDidLoad];
    self.title = @"股红";
    self.view.backgroundColor = GREY_DARK;
    // Do any additional setup after loading the view.
    
    
    SBBrokersTableViewController *cvc = [[SBBrokersTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [cvc.tableView setDelegate:self];
    self.brokerListPopover = [[UIPopoverController alloc] initWithContentViewController:cvc];
    [self.brokerListPopover setPopoverContentSize:CGSizeMake(240, 240)];
    
    self.inputBackground.layer.cornerRadius = 10;
//    [self.inputBackground setDynamic:NO];
    [self.inputBackground setClipsToBounds:YES];

    
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
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground:)];
    gr.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gr];

    
    
    
}

-(void)tappedBackground:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self hideKeyboard];
    }
}

-(void)hideKeyboard
{
    for (UIView *view in self.inputBackground.subviews) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
            break;
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[animationDuration doubleValue] animations:^{
        self.logoImageView.transform = CGAffineTransformIdentity;
        self.inputBackground.transform = CGAffineTransformIdentity;
        self.loginButton.transform = CGAffineTransformIdentity;
    }];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGAffineTransform t = CGAffineTransformMakeScale(0.91, 0.91);
    t = CGAffineTransformTranslate(t, 0, -120);
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, -keyboardFrame.size.height + 60);
    
    [UIView animateWithDuration:[animationDuration doubleValue] animations:^{
        self.logoImageView.transform = t;
        self.inputBackground.transform = t1;
        self.loginButton.transform = t1;

    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.brokerListPopover dismissPopoverAnimated:YES];
    self.selectedBroker = [[SBDataManager sharedManager] brokerList][(NSUInteger) indexPath.row];
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
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedin"];
    [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:@"password"];

    [self hideKeyboard];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username": self.usernameField.text, @"password": self.passwordField.text};
    NSString *urlString = [NSString stringWithFormat: @"%@auth/login", SERVER_URL];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!((NSDictionary *) responseObject)[@"error"]) {
            
            NSString *cookie = operation.response.allHeaderFields[@"Set-Cookie"];
            [[SBDataManager sharedManager] setAuthCookie:cookie];
            
            SBUserAlgoTableViewController *avc = [[SBUserAlgoTableViewController alloc] initWithStyle:UITableViewStylePlain];
            
            //    id <UIViewControllerTransitioningDelegate> t = [SBLoginAnimatedTransitioningDelegate new];
            //    avc.transitioningDelegate = t;
            
            SBNavigationControllerDelegate *d = [SBNavigationControllerDelegate sharedDelegate];
            self.navigationController.delegate = d;
            
            [self.navigationController pushViewController:avc animated:YES];
            [self.navigationController setViewControllers:@[avc]];
        } else {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"用户名或密码错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [errorAlertView show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    return;




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
