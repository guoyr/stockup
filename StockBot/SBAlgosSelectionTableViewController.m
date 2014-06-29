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
#import "SBSegmentedControl.h"

#define HEADER_BORDER 12
#define SEG_CONTROL_WIDTH 192-HEADER_BORDER*2

@interface SBAlgosSelectionTableViewController ()

@property (nonatomic, strong) SBAlgorithm *algorithm;
@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *selectedAlgorithmIndices;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SBSegmentedControl *buySellControl;
@property (nonatomic, strong) SBSegmentedControl *priceControl;
@property (nonatomic, strong) UIColor *cellBackgroundColor;

@end

@implementation SBAlgosSelectionTableViewController

static NSString *CustomizeCellIdentifier = @"CCell";
static NSString *AlgoNameCellIdentifier = @"ACell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setClipsToBounds:YES];
    
    [self.tableView registerClass:[SBAlgoConditionTableViewCell class] forCellReuseIdentifier:CustomizeCellIdentifier];
    [self.tableView registerClass:[SBAlgoSelectTableViewCell class] forCellReuseIdentifier:AlgoNameCellIdentifier];

    self.tableView.separatorColor = GREEN_0;
    [self.tableView setBackgroundColor:BLACK];
    [self.tableView setRowHeight:ALGO_ROW_HEIGHT];
    
    CGRect newFrame = self.tableView.frame;
    newFrame.origin.y += ALGO_ROW_HEIGHT;
    newFrame.size.height -= ALGO_ROW_HEIGHT;
    self.tableView.frame = newFrame;
    
    self.expandedIndexPaths = [NSMutableArray new];
    self.selectedAlgorithmIndices = [NSMutableArray new];

    self.cellBackgroundColor = [UIColor redColor];

    [self setupAlgorithm];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //performSelector selectorfromstring
}

// setup the selected controls for the algorithm depending on what is selected
-(void)setupAlgorithm
{
    // get this from the manager
    self.algorithm = [[SBDataManager sharedManager] selectedAlgorithm];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALGO_LIST_WIDTH, ALGO_ROW_HEIGHT)];
    self.headerView.backgroundColor = BLACK;
    [self.view addSubview:self.headerView];
    
    self.buySellControl = [[SBSegmentedControl alloc] initWithItems:@[@"买入", @"卖出"]];
    self.buySellControl.frame = CGRectMake(HEADER_BORDER, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
    self.buySellControl.alpha = 0.0f;
    [self.buySellControl addTarget:self action:@selector(buySellControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.priceControl = [[SBSegmentedControl alloc] initWithItems:@[@"市场价",@"限价单"]];
    self.priceControl.frame = CGRectMake(HEADER_BORDER, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
    self.priceControl.alpha = 0.0f;
    [self.priceControl addTarget:self action:@selector(marketLimitedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.algorithm.mandatoryControls = @[self.buySellControl, self.priceControl];
    
    [self.headerView addSubview:self.buySellControl];
    [self.headerView addSubview:self.priceControl];
    
    self.buySellControl.alpha = 1.0f;
    
}

#define BUY_INDEX 0
#define SELL_INDEX 1
#define MARKET_PRICE_INDEX 0
#define LIMITED_PRICE_INDEX 1

#pragma mark SegmentedControl helper methods

-(void)showControlsSideBySide
{
    CGRect frame = CGRectMake(HEADER_BORDER, HEADER_BORDER, SEG_CONTROL_WIDTH, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
    for (SBSegmentedControl *control in self.algorithm.mandatoryControls) {
        control.frame = frame;
        frame.origin.x += SEG_CONTROL_WIDTH + HEADER_BORDER * 2;
        control.userInteractionEnabled = YES;
        control.alpha = 1.0f;
        [control shrink];
        [control layoutIfNeeded];

    }
}

-(void)showControlFullScreen:(SBSegmentedControl *)control
{
    
    for (SBSegmentedControl *curControl in self.algorithm.mandatoryControls) {
        if (control == curControl) {
            curControl.frame = CGRectMake(HEADER_BORDER, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
            curControl.alpha = 1.0f;
            curControl.userInteractionEnabled = YES;
            [curControl expand];
        } else {
            curControl.alpha = 0.0f;
            curControl.userInteractionEnabled = NO;
            if (curControl.frame.origin.x < control.frame.origin.x) {
                // move left
                curControl.frame = CGRectMake(-ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);

            } else {
                // move right
                curControl.frame = CGRectMake(ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);

            }
        }
    }
    

}

-(void)buySellControlValueChanged:(SBSegmentedControl *)control
{
    if (!control.isExpanded) {
        // showing only the summary, expand
        [UIView animateWithDuration:0.3 animations:^{
//            [self showControlFullScreen:control];

        } completion:^(BOOL finished) {

        }];
    } else {

        if (!self.algorithm.orderCondition) {
            // showing price information for the first time
            
            self.priceControl.frame = CGRectMake(ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
            [UIView animateWithDuration:0.3 animations:^{
                [self showControlFullScreen:self.priceControl];
                self.buySellControl.frame = CGRectMake(-ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);

            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self showControlsSideBySide];

            }completion:^(BOOL finished) {
                ;
            }];
        }
    }
    
    switch (control.selectedSegmentIndex) {
        case BUY_INDEX:
            self.cellBackgroundColor = [UIColor redColor];
            break;
        case SELL_INDEX:
            self.cellBackgroundColor = [UIColor greenColor];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    self.algorithm.buySellCondition = control.selectedSegmentIndex + 1;
    
    
}

-(void)marketLimitedControlValueChanged:(SBSegmentedControl *)control
{
    if (!control.isExpanded) {
        // showing only the summary, expand
        [UIView animateWithDuration:0.3 animations:^{
//            [self showControlFullScreen:control];
            
        } completion:^(BOOL finished) {

        }];
    } else {
        switch (control.selectedSegmentIndex) {
            case MARKET_PRICE_INDEX:
                ;
                break;
            case LIMITED_PRICE_INDEX:
                ;
                break;
            default:
                break;
        }
        
        
        self.algorithm.orderCondition = control.selectedSegmentIndex + 1;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self showControlsSideBySide];
        } completion:^(BOOL finished) {

        }];
    }

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
    cell.backgroundColor = self.cellBackgroundColor;
    
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
            curAlgo.delegate = self;
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
    NSMutableArray *expandedIndexPaths = [NSMutableArray new];
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
        [self.delegate viewController:self didViewCondition:curAlgo];
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
        [self.delegate viewController:self didViewCondition:curAlgo];

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
        [self.delegate viewController:self didAddCondition:[self.algorithm conditionAtIndex:button.tag]];

    } else {
        [button setTitle:@"添加条件" forState:UIControlStateNormal];
        [self.algorithm conditionAtIndex:button.tag].isSelected = NO;
        [self.selectedAlgorithmIndices removeObject:[NSNumber numberWithLong:button.tag]];
        [self.delegate viewController:self didRemoveCondition:[self.algorithm conditionAtIndex:button.tag]];
    }
    
}

#pragma mark SBCondition delegate

-(void)conditionDidChange:(SBCondition *)condition
{
    [self.delegate viewController:self didModifyCondition:condition];
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
