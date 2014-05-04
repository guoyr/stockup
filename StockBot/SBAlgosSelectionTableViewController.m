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
#import "SBAlgorithms.h"

@interface SBAlgosSelectionTableViewController ()

@property (nonatomic, strong) NSArray *algorithms;
@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation SBAlgosSelectionTableViewController

static NSString *CellIdentifier = @"AlgoCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

    [self.view setBackgroundColor:BLACK];
    [self.tableView setRowHeight:ALGO_ROW_HEIGHT];
    
    self.expandedIndexPaths = [[NSMutableArray alloc] init];
    [self setupAlgorithms];
    
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
    if (self.selectedIndexPath) {
        return [self.algorithms count] + [self.expandedIndexPaths count];
    }
    return [self.algorithms count];
}

-(void)setupAlgorithms
{
    SBMACDAlgorithm *a1 = [[SBMACDAlgorithm alloc] init];
    SBKDJAlgorithm *a2 = [[SBKDJAlgorithm alloc] init];
    
    self.algorithms = @[a1,a2];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlgoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = BLUE_4;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    cell.textLabel.textColor = WHITE;
    
    NSInteger curAlgoIndex = indexPath.row;
    if (self.selectedIndexPath && indexPath.row > self.selectedIndexPath.row) {
        if (indexPath.row > self.selectedIndexPath.row + [self.expandedIndexPaths count]) {
            // another algorithm after the expanded section
            curAlgoIndex -= [self.expandedIndexPaths count];
        } else {
            // options for the current algorithm
            SBAlgorithm *curAlgo = self.algorithms[self.selectedIndexPath.row];
            NSInteger curAlgoOptionsIndex = indexPath.row - self.selectedIndexPath.row;
            [curAlgo setupCell:cell AtIndex:curAlgoOptionsIndex];
            return cell;
        }
    }
    
    SBAlgorithm *curAlgo = self.algorithms[curAlgoIndex];
    cell.textLabel.text = curAlgo.description;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if ([self.expandedIndexPaths containsObject:indexPath]) {
        // algorithm customization cells are not selectable
        return;
    }
//    [self.delegate viewController:self didViewAlgorithm:self.algorithms[indexPath.row]];
    NSInteger curAlgoIndex = indexPath.row;
    if (self.selectedIndexPath && indexPath.row > self.selectedIndexPath.row) {
        curAlgoIndex -= [self.expandedIndexPaths count];
    }
    SBAlgorithm *curAlgo = self.algorithms[curAlgoIndex];
    NSMutableArray *expandedIndexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < [curAlgo numExpandedRows]+1 ; i++) {
        [expandedIndexPaths addObject:[NSIndexPath indexPathForRow:curAlgoIndex + i inSection:indexPath.section]];
    }
    NSLog(@"%@, %@, %ld",curAlgo.description, expandedIndexPaths, indexPath.length);

    if (!self.selectedIndexPath) {
        // no rows are selected
        self.selectedIndexPath = indexPath;
        self.expandedIndexPaths = expandedIndexPaths;
        [self.tableView insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if ([self.selectedIndexPath isEqual:indexPath]) {
        // deselect indexpath
        self.selectedIndexPath = nil;
        [self.tableView deleteRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // selected new indexpath
        self.selectedIndexPath = [NSIndexPath indexPathForRow:curAlgoIndex inSection:indexPath.section];;
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:self.expandedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        self.expandedIndexPaths = expandedIndexPaths;
        [self.tableView insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did deselect %ld",(long)indexPath.row);

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

#pragma mark Private Helper Methods


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
