//
//  SBStocksListTableViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBStocksListTableViewController.h"
#import "SBDataManager.h"
#import "SBStock.h"
#import "SBConstants.h"
#import "SBStocksTableViewCell.h"
#import "SBAlgorithm.h"
#import "SBStocksDetailViewController.h"

@interface SBStocksListTableViewController ()

@property (nonatomic, strong) SBDataManager *dataManager;

@property (nonatomic, strong) UISearchBar *stockSearchBar;
@property (nonatomic, strong) NSArray *searchedStockArray;

@end

@implementation SBStocksListTableViewController

static NSString *CellIdentifier = @"StockCell";


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataManager = [SBDataManager sharedManager];
    [self.tableView registerClass:[SBStocksTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView setRowHeight:STOCK_CELL_HEIGHT];
    [self.tableView setBackgroundColor:BLACK_BG];
    self.tableView.separatorColor = BLACK_BG;
    

    self.stockSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    self.stockSearchBar.translucent = YES;
    self.stockSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.stockSearchBar.delegate = self;
    [self.stockSearchBar sizeToFit];
    self.stockSearchBar.barTintColor = BLACK_BG;
    self.stockSearchBar.placeholder = @"股票号码";
    
    self.tableView.tableHeaderView = self.stockSearchBar;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.stockSearchBar.showsCancelButton = YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"stockIDString contains[c] %@", searchText];
        self.searchedStockArray = [[_dataManager stocks] filteredArrayUsingPredicate:resultPredicate];
    } else {
        self.searchedStockArray = nil;
    }
    [self.tableView reloadData];
   
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.stockSearchBar.text = @"";
    [self.stockSearchBar resignFirstResponder];
    self.stockSearchBar.showsCancelButton = NO;
    [self.tableView reloadData];
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
    if (self.searchedStockArray) {
        return self.searchedStockArray.count;
    }
    return self.dataManager.stocks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBStocksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    SBStock *stock;
    if (self.searchedStockArray) {
        stock = (self.searchedStockArray)[(NSUInteger) indexPath.row];
    } else {
        stock = (self.dataManager.stocks)[(NSUInteger) indexPath.row];
        if ([stock.stockID isEqual:self.curAlgo.stockID]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self.delegate viewController:self didSelectStock:stock];
        }
        
    }
    stock.tableViewIndex = indexPath;
    cell.stockIDLabel.text = [stock.stockID stringValue];
    cell.stockNameLabel.text = stock.name;
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.stockSearchBar isFirstResponder]) {
        [self.stockSearchBar resignFirstResponder];
    }
    SBStock *selectedStock;
    if (self.searchedStockArray) {
        selectedStock = self.searchedStockArray[(NSUInteger) indexPath.row];
    } else {
        selectedStock = self.dataManager.stocks[(NSUInteger) indexPath.row];
    }
    [self.delegate viewController:self didSelectStock:selectedStock];
     
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

@end
