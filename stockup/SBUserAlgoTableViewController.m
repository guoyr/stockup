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
#import "SBConstants.h"

#define TABLEVIEW_SEGMENT_CONTROL_HEIGHT 64

@interface SBUserAlgoTableViewController ()

@property (nonatomic, strong) NSDictionary *algoDict;
@property (nonatomic, strong) UISegmentedControl *tableViewStyleControl;
@property (nonatomic, strong) SBStocksViewController *stockVC;

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
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.algoDict = [[NSMutableDictionary alloc] init];
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(SBStocksViewController *)stockVC
{
    if (!_stockVC) {
        _stockVC = [[SBStocksViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _stockVC;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.algoDict = [[SBDataManager sharedManager] allAlgorithms];
    [self.tableView reloadData];
}

-(void)addAlgorithm:(id)sender
{
    if (!self.curAlgo) {
        self.curAlgo = [SBAlgorithm new];
    }
    self.stockVC.curAlgo = self.curAlgo;
    [self.navigationController pushViewController:self.stockVC animated:YES];
}

-(void)logout:(id)sender
{
    
    UIAlertView *logoutConfirmation = [[UIAlertView alloc] initWithTitle:@"确认注销" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [logoutConfirmation show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SBLoginViewController *vc;
    switch (buttonIndex) {
        case 1:
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"presentedInstruction"];
            [[SBDataManager sharedManager] setAuthCookie:nil];
            self.navigationController.delegate = [SBNavigationControllerDelegate sharedDelegate];
            vc =[[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController setViewControllers:@[vc, self] animated:NO];
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
    NSArray *algoNames = self.algoDict.allKeys;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
    NSString *algoUID = algoNames[indexPath.row];
    SBAlgorithm *algo = (SBAlgorithm *)self.algoDict[algoUID];
    UILabel *stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 60, 40)];
    stockNameLabel.text = [algo.stockID stringValue];
    [cell addSubview:stockNameLabel];
    cell.textLabel.text = [algo name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *algoNames = self.algoDict.allKeys;
    self.curAlgo = self.algoDict[algoNames[indexPath.row]];
    [self addAlgorithm:nil];
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
    NSArray *algoNames = self.algoDict.allKeys;

    NSUInteger count = [algoNames count];
    if (!count) {
        self.tableViewStyleControl.enabled = NO;
    } else {
        self.tableViewStyleControl.enabled = YES;
    }
    return count;
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
        NSArray *algoNames = self.algoDict.allKeys;

        [[SBDataManager sharedManager] removeAlgorithm:algoNames[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark DZN Data Source

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请添加您的第一支算法";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24.0],
                                 NSForegroundColorAttributeName: WHITE};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您可以使用算法来表达一系列交易条件，满足这些条件是，我们便会提醒您交易";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: WHITE,
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0], NSForegroundColorAttributeName:BLUE};
    
    return [[NSAttributedString alloc] initWithString:@"继续" attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return BLACK_BG;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"logo"];
}

#pragma mark DZN Delegate

-(void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self addAlgorithm:nil];
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
