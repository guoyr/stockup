//
//  SBAlgosListTableViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgosSelectionTableViewController.h"
#import "SBConstants.h"
#import "SBAlgoTableViewCell.h"
#import "SBAlgorithmsManager.h"

@interface SBAlgosSelectionTableViewController ()

@property (nonatomic, strong) NSArray *algorithms;
@property (nonatomic, strong) NSMutableIndexSet *expandedRows;

@end

@implementation SBAlgosSelectionTableViewController

static NSString *CellIdentifier = @"AlgoCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.algorithms = @[@"MACD", @"Price"];

    [self.tableView registerClass:[SBAlgoTableViewCell class] forCellReuseIdentifier:CellIdentifier];

    [self.view setBackgroundColor:BLACK];
    [self.tableView setRowHeight:ALGO_ROW_HEIGHT];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //performSelector selectorfromstring
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.algorithms count];
}

-(void)setupCells:(UITableViewCell *)cell
{
    [self setupMACDCell:cell];
    [self setupBuyCells:cell];
    [self setupSellCells:cell];
    [self setupPriceCell:cell];
}

-(void)setupBuyCells:(UITableViewCell *)cell
{
    
}

-(void)setupSellCells:(UITableViewCell *)cell
{
    
}

-(void)setupMACDCell:(UITableViewCell *)cell
{
    
}

-(void)setupPriceCell:(UITableViewCell *)cell
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlgoCell";
    SBAlgoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.confirmButton addTarget:self action:@selector(confirmedCondition:) forControlEvents:UIControlEventTouchUpInside];
    cell.confirmButton.tag = indexPath.row;
    NSString *algoString = [NSString stringWithFormat:@"setup%@Cell:",self.algorithms[indexPath.row]];
    SEL selector = NSSelectorFromString(algoString);
    
    [[SBAlgorithmsManager sharedManager] performSelector:selector withObject:cell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate viewController:self didViewAlgorithm:self.algorithms[indexPath.row]];
}

-(void)confirmedCondition:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"添加条件"]) {
        [button setTitle:@"删除条件" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"添加条件" forState:UIControlStateNormal];
    }
    NSLog(@"confirmedCondition, %ld", (long)button.tag);
    [self.delegate viewController:self didSelectAlgorithm:self.algorithms[button.tag]];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
