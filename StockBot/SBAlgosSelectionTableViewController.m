//
//  SBAlgosListTableViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgosSelectionTableViewController.h"
#import "SBAlgoConditionTableViewCell.h"
#import "SBAlgorithm.h"
#import "SBAlgoSelectTableViewCell.h"
#import "SBDataManager.h"

@interface SBAlgosSelectionTableViewController ()

@property (nonatomic, strong) SBAlgorithm *algorithm;
@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *selectedAlgorithmIndices;

@end

@implementation SBAlgosSelectionTableViewController

static NSString *CustomizeCellIdentifier = @"CCell";
static NSString *AlgoNameCellIdentifier = @"ACell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[SBAlgoConditionTableViewCell class] forCellReuseIdentifier:CustomizeCellIdentifier];
    [self.tableView registerClass:[SBAlgoSelectTableViewCell class] forCellReuseIdentifier:AlgoNameCellIdentifier];

    self.tableView.separatorColor = GREEN_0;
    [self.view setBackgroundColor:BLACK];
    [self.tableView setRowHeight:ALGO_ROW_HEIGHT];
    
    self.expandedIndexPaths = [[NSMutableArray alloc] init];
    self.selectedAlgorithmIndices = [[NSMutableArray alloc] init];

    // get this from the manager
    self.algorithm = [[SBDataManager sharedManager] selectedAlgorithm];
    
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
        return self.algorithm.numConditions + [self.expandedIndexPaths count];
    }
    return self.algorithm.numConditions;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger curAlgoIndex = indexPath.row;
    SBAlgoSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlgoNameCellIdentifier];
    [cell.confirmButton addTarget:self action:@selector(confirmedCondition:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    if (self.selectedIndexPath && indexPath.row > self.selectedIndexPath.row) {
        if (indexPath.row > self.selectedIndexPath.row + [self.expandedIndexPaths count]) {
            // another algorithm after the expanded section
            curAlgoIndex -= [self.expandedIndexPaths count];
        } else {
            // options for the current algorithm
            SBAlgoConditionTableViewCell *customizeCell = [tableView dequeueReusableCellWithIdentifier:CustomizeCellIdentifier];
            [customizeCell resetCell];
            SBCondition *curAlgo = [self.algorithm conditionAtIndex:self.selectedIndexPath.row];
            NSInteger curAlgoOptionsIndex = indexPath.row - self.selectedIndexPath.row;
            [curAlgo setupCell:customizeCell AtIndex:curAlgoOptionsIndex];
            return customizeCell;
        }
    }
    
    SBCondition *curAlgo = [self.algorithm conditionAtIndex:curAlgoIndex];
    
    // already selected the algorithm
    if ([self.selectedAlgorithmIndices containsObject:[NSNumber numberWithLong:curAlgoIndex]]) {
        [cell.confirmButton setTitle:@"删除条件" forState:UIControlStateNormal];
    }
    cell.confirmButton.tag = curAlgoIndex;
    cell.textLabel.text = curAlgo.description;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.expandedIndexPaths containsObject:indexPath]) {
        // algorithm customization cells are not selectable
        return NO;
    }
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger curAlgoIndex = indexPath.row;
    if (self.selectedIndexPath && indexPath.row > self.selectedIndexPath.row) {
        curAlgoIndex -= [self.expandedIndexPaths count];
    }
    SBCondition *curAlgo = [self.algorithm conditionAtIndex:curAlgoIndex];
    NSMutableArray *expandedIndexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < [curAlgo numExpandedRows]+1 ; i++) {
        [expandedIndexPaths addObject:[NSIndexPath indexPathForRow:curAlgoIndex + i inSection:indexPath.section]];
    }
    if (!self.selectedIndexPath) {
        // no rows are selected
        self.selectedIndexPath = indexPath;
        self.expandedIndexPaths = expandedIndexPaths;
        if (expandedIndexPaths.count) {
            [self.tableView insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else if ([self.selectedIndexPath isEqual:indexPath]) {
        // deselect indexpath
        self.selectedIndexPath = nil;
        self.expandedIndexPaths = nil;
        if (expandedIndexPaths.count) {
            [self.tableView deleteRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        // selected new indexpath
        self.selectedIndexPath = [NSIndexPath indexPathForRow:curAlgoIndex inSection:indexPath.section];;
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:self.expandedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        if (expandedIndexPaths) {
            self.expandedIndexPaths = expandedIndexPaths;
            [self.tableView insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];
    }
    
}

-(void)confirmedCondition:(UIButton *)button
{
    //TODO: eventually change to a checkmark
    NSNumber *index = [NSNumber numberWithLong:button.tag];
    if (![self.selectedAlgorithmIndices containsObject:index]) {
        [button setTitle:@"删除条件" forState:UIControlStateNormal];
        [self.selectedAlgorithmIndices addObject:[NSNumber numberWithLong:button.tag]];
        [self.algorithm conditionAtIndex:button.tag].isSelected = YES;
        [self.delegate viewController:self didSelectCondition:[self.algorithm conditionAtIndex:button.tag]];

    } else {
        [button setTitle:@"添加条件" forState:UIControlStateNormal];
        [self.algorithm conditionAtIndex:button.tag].isSelected = NO;
        [self.selectedAlgorithmIndices removeObject:[NSNumber numberWithLong:button.tag]];
    }
    
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
