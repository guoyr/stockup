//
//  SBUserAlgoTableViewController.m
//  StockBot
//
//  Created by Robert Guo on 4/17/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBUserAlgoTableViewController.h"
#import "SBLoginViewController.h"
#import "SBStocksViewController.h"
#import "SBAlgorithm.h"
#import "SBDataManager.h"
#import "SBNavigationControllerDelegate.h"

#define TABLEVIEW_SEGMENT_CONTROL_HEIGHT 64

@interface SBUserAlgoTableViewController ()

@property (nonatomic, strong) NSDictionary *algoDict;
@property (nonatomic, strong) NSArray *algoNames;
@property (nonatomic, strong) UISegmentedControl *tableViewStyleControl;

@end

@implementation SBUserAlgoTableViewController

static NSString *UserCellIdentifier = @"UserCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.leftBarButtonItem = logout;
    
    UIBarButtonItem *addAlgo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlgorithm:)];
    self.navigationItem.rightBarButtonItem = addAlgo;
    self.title = @"用户股票列表";
    self.tableView.rowHeight = USER_ALGO_LIST_HEIGHT;
    
    CGRect newFrame = self.tableView.frame;
    newFrame.size.height -= TABLEVIEW_SEGMENT_CONTROL_HEIGHT;
    self.tableView.frame = newFrame;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UserCellIdentifier];

    self.tableViewStyleControl = [[UISegmentedControl alloc] initWithItems:@[@"所有算法", @"所有股票"]];
    self.tableViewStyleControl.frame = CGRectMake(0, 960, 768, TABLEVIEW_SEGMENT_CONTROL_HEIGHT);
    self.tableViewStyleControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.tableViewStyleControl];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.algoDict = [[SBDataManager sharedManager] getAllAlgorithmsForUser:nil];
    self.algoNames = [[SBDataManager sharedManager] allAlgoName];
    [self.tableView reloadData];
    
    [self.view bringSubviewToFront:self.tableViewStyleControl];
    
    if (!self.algoNames.count) {
//        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"presentedInstruction"]) {
        if (1) {
            SBInstructionsViewController *ivc = [[UIStoryboard storyboardWithName:@"Instructions" bundle:nil] instantiateViewControllerWithIdentifier:@"VC"];
            ivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            ivc.modalPresentationStyle = UIModalPresentationFormSheet;
            
            [ivc setDelegate:self];
            [self.navigationController presentViewController:ivc animated:YES completion:^{
                ;
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"presentedInstruction"];
        }
        
    }
}

-(void)instructionViewControllerDidConfirm:(SBInstructionsViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self addAlgorithm:vc];
    }];
}

-(void)instructionViewControllerDidDismiss:(SBInstructionsViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)addAlgorithm:(id)sender
{
    SBStocksViewController *algoVC = [[SBStocksViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:algoVC animated:YES];
}

-(void)logout:(id)sender
{
    
    UIAlertView *logoutConfirmation = [[UIAlertView alloc] initWithTitle:@"确认注销" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"presentedInstruction"];
    [logoutConfirmation show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedin"];
            self.navigationController.delegate = [SBNavigationControllerDelegate sharedDelegate];
            [self.navigationController popViewControllerAnimated:YES];

            break;
        case 0:
            ;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
    cell.textLabel.text = self.algoNames[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *algoName = self.algoNames[indexPath.row];
    SBAlgorithm *algo = self.algoDict[algoName];
    SBDataManager *manager = [SBDataManager sharedManager];
    [manager setSelectedAlgorithm:algo];
    SBStock *stock = [manager stocks][indexPath.row];
    [manager setSelectedStock:stock];
    SBStocksViewController *svc = [[SBStocksViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.algoDict allKeys].count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [[SBDataManager sharedManager] removeAlgorithm:self.algoNames[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
