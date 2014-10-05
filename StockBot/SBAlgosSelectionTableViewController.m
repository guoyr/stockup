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
#import "SBConstants.h"

@interface SBAlgosSelectionTableViewController ()

@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *selectedConditionIndices;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIColor *stockTintColor;

@property (nonatomic, strong) SBSegmentedControl *curVisibleSegmentedControl;

@end

@implementation SBAlgosSelectionTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setClipsToBounds:YES];
    
    self.tableView.separatorColor = BLACK_BG;
    [self.tableView setBackgroundColor:BLACK_BG];
    [self.tableView setRowHeight:ALGO_ROW_HEIGHT];
    
    CGRect newFrame = self.tableView.frame;
    newFrame.origin.y += ALGO_ROW_HEIGHT;
    newFrame.size.height -= ALGO_ROW_HEIGHT;
    self.tableView.frame = newFrame;
    
    self.expandedIndexPaths = [NSMutableArray new];
    self.selectedConditionIndices = [NSMutableArray new];

    self.stockTintColor = GREY_LIGHT;
    
    self.navigationController.navigationBar.tintColor = self.stockTintColor;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //performSelector selectorfromstring
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupAlgorithm];
}

// setup the selected controls for the algorithm depending on what is selected
-(void)setupAlgorithm
{
    // get this from the manager
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALGO_LIST_WIDTH, ALGO_ROW_HEIGHT)];
    self.headerView.backgroundColor = BLACK_BG;

    [self.view addSubview:self.headerView];

    for (SBMandatoryCondition *condition in self.curAlgo.mandatoryConditions) {
        // TODO: setup the segmented controls if necessary
        [self.headerView addSubview:condition.segmentedControl];
        condition.delegate = self;
    }
    
    SBSegmentedControl *firstControl = [self.curAlgo.mandatoryConditions[0] segmentedControl];
    [self showControlFullScreen:firstControl];
    
}

#pragma mark SegmentedControl helper methods

-(void)showControlsSideBySide
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(HEADER_BORDER, HEADER_BORDER, SEG_CONTROL_WIDTH, ALGO_ROW_HEIGHT - HEADER_BORDER*2);

        for (SBMandatoryCondition *condition in self.curAlgo.mandatoryConditions) {
            SBSegmentedControl *control = condition.segmentedControl;
            control.frame = frame;
            frame.origin.x += SEG_CONTROL_WIDTH + HEADER_BORDER * 2;
            control.alpha = 1.0f;
            //        [control shrink];
            [control layoutIfNeeded];
            
        }
    }];
    self.curVisibleSegmentedControl = nil;

}

-(void)showControlFullScreen:(SBSegmentedControl *)control
{
    CGRect fullScreenFrame = CGRectMake(HEADER_BORDER, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);

    if (self.curVisibleSegmentedControl) {
        // something is already visible, move it to the left
        control.frame = CGRectMake(ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
        control.alpha = 1.0f;
        [UIView animateWithDuration:0.3 animations:^{
            self.curVisibleSegmentedControl.frame = CGRectMake(-ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
            control.frame = fullScreenFrame;
        } completion:^(BOOL finished) {
            self.curVisibleSegmentedControl.alpha = 0.0f;
            self.curVisibleSegmentedControl = control;

        }];
    } else {
        control.frame = fullScreenFrame;
        control.alpha = 1.0f;
        self.curVisibleSegmentedControl = control;

    }
    
//    for (SBMandatoryCondition *condition in self.algorithm.mandatoryConditions) {
//        SBSegmentedControl *curControl = condition.segmentedControl;
//        if (control == curControl) {
//            curControl.frame = CGRectMake(HEADER_BORDER, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
//            curControl.alpha = 1.0f;
//            curControl.userInteractionEnabled = YES;
//
//            [curControl expand];
//        } else { 
//            curControl.alpha = 0.0f;
//            curControl.userInteractionEnabled = NO;
//            if (curControl.frame.origin.x < control.frame.origin.x) {
//                // move left
//                curControl.frame = CGRectMake(-ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
//
//            } else {
//                // move right
//                curControl.frame = CGRectMake(ALGO_LIST_WIDTH, HEADER_BORDER, ALGO_LIST_WIDTH - HEADER_BORDER*2, ALGO_ROW_HEIGHT - HEADER_BORDER*2);
//
//            }
//        }
//    }
    

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
        return self.curAlgo.numConditions + [self.expandedIndexPaths count];
    }
    return self.curAlgo.numConditions;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger curAlgoIndex = indexPath.row;
    SBAlgoSelectTableViewCell *cell = [[SBAlgoSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell.confirmButton addTarget:self action:@selector(confirmedCondition:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.selectedIndexPath && indexPath.row > self.selectedIndexPath.row) {
        if (indexPath.row > self.selectedIndexPath.row + [self.expandedIndexPaths count]) {
            // another algorithm after the expanded section
            curAlgoIndex -= [self.expandedIndexPaths count];
        } else {
            // options for the current algorithm
            SBAlgoConditionTableViewCell *customizeCell = [[SBAlgoConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            [customizeCell resetCell];
            customizeCell.bgView.backgroundColor = self.stockTintColor;
            SBCondition *curCondition = [self conditionAtIndex:self.selectedIndexPath.row];
            curCondition.delegate = self;
            NSInteger curAlgoOptionsIndex = indexPath.row - self.selectedIndexPath.row;
            [curCondition setupCell:customizeCell AtIndex:curAlgoOptionsIndex];
            curCondition.delegate = self;
            return customizeCell;
        }
    }
    
    SBCondition *curAlgo = [self conditionAtIndex:curAlgoIndex];
    
    // already selected the condition
    if ([self.selectedConditionIndices containsObject:@(curAlgoIndex)]) {
        [cell.confirmButton setTitle:@"-" forState:UIControlStateNormal];
    }
    [cell setStockTintColor:self.stockTintColor];
    cell.confirmButton.tag = curAlgoIndex;
    cell.textLabel.text = curAlgo.conditionDescription;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ![self.expandedIndexPaths containsObject:indexPath];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger curAlgoIndex = indexPath.row;
    if (self.selectedIndexPath && indexPath.row > self.selectedIndexPath.row) {
        curAlgoIndex -= [self.expandedIndexPaths count];
    }
    SBCondition *curAlgo = [self conditionAtIndex:curAlgoIndex];
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

-(SBCondition *)conditionAtIndex:(NSInteger)index
{
    SBCondition *condition;
    SBAlgorithm *algorithm = self.curAlgo;
    switch (index) {
        case 0:
            condition = algorithm.macdCondition;
            break;
        case 1:
            condition = algorithm.kdjCondition;
            break;
        case 2:
            condition = algorithm.volumeCondtion;
            break;
        case 3:
            condition = algorithm.bollCondition;
            break;
        case 4:
            condition = algorithm.priceCondition;
            break;
        default:
            break;
    }
    return condition;
}

-(void)confirmedCondition:(UIButton *)button
{
    //TODO: eventually change to a checkmark
    NSNumber *index = @(button.tag);
    if (![self.selectedConditionIndices containsObject:index]) {
        [button setTitle:@"-" forState:UIControlStateNormal];
        [self.selectedConditionIndices addObject:@(button.tag)];
        [self conditionAtIndex:button.tag].isSelected = YES;
        [self.delegate viewController:self didAddCondition:[self conditionAtIndex:button.tag]];

    } else {
        [button setTitle:@"+" forState:UIControlStateNormal];
        [self conditionAtIndex:button.tag].isSelected = NO;
        [self.selectedConditionIndices removeObject:@(button.tag)];
        [self.delegate viewController:self didRemoveCondition:[self conditionAtIndex:button.tag]];
    }
    if ([self.selectedConditionIndices count] > 0)
        self.curAlgo.primaryCondition = [self conditionAtIndex:[self.selectedConditionIndices[0] integerValue]];
    else self.curAlgo.primaryCondition = nil;

}

#pragma mark SBCondition delegate

-(void)conditionDidChange:(SBCondition *)condition
{
    NSLog(@"condition did change");
    if ([self.curAlgo.mandatoryConditions containsObject:condition] && self.curVisibleSegmentedControl) {
        if ([condition class] == [SBTradeMethodCondition class]) {
            [self showControlFullScreen:[self.curAlgo.mandatoryConditions[1] segmentedControl]];
        } else {
            [self showControlsSideBySide];
        }
    }
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
