//
//  SBStocksDataManager.m
//  StockBot
//
//  Created by Robert Guo on 2/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "SBDataManager.h"
#import "SBConstants.h"
#import "SBStock.h"
#import "SBAlgorithm.h"
#import "NSString+SBAdditions.h"
@interface SBDataManager()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *rowCache; //caching csv data as we transfer it to fmdb
@property (nonatomic, strong) NSMutableDictionary *allAlgorithms;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SBDataManager

+ (id)sharedManager {
    static SBDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
    });
    return sharedMyManager;
}

-(SBAlgorithm *)selectedAlgorithm
{
    if (!_selectedAlgorithm) {
        _selectedAlgorithm = [SBAlgorithm new];
    }
    return _selectedAlgorithm;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stockList" ofType:@"csv"];
        NSInputStream *pathStream = [NSInputStream inputStreamWithFileAtPath:path];
        //TODO: convert this to use synced data from the server in the future.
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [paths[0] stringByAppendingString:@"/stocks.db"];
        
        self.brokerList = @[@"中信证券", @"民族证券", @"民生证券"];

        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateFormat:@"yy-MM-dd_HH:mm:ss"];
        
        self.db = [[FMDatabase alloc] initWithPath:dbPath];
        [self.db open];
        BOOL success = [self.db executeUpdate:@"create table if not exists sse_stocks(name nvarchar(256), stock_id integer)"];
        [self showErrorIfFailed:success];
        FMResultSet *result = [self.db executeQuery:@"select count(*) from sse_stocks"];
        while ([result next]) {
            int stockCount = [result intForColumnIndex:0];
            NSLog(@"number of rows %d", stockCount);
            if (stockCount == 0) {
                // create the db from the csv file
                self.rowCache = [NSMutableArray arrayWithCapacity:2];
                
                CHCSVParser *parser = [[CHCSVParser alloc] initWithInputStream:pathStream usedEncoding:nil delimiter:','];
                [parser setDelegate:self];
                [parser parse];
            } else {
                // DB already exists
                NSLog(@"DB already exists");
            }
        }
        
        self.allAlgorithms = [NSMutableDictionary new];
    }
    
    return self;
}

-(NSString *)defaultAlgorithmName
{
    return [NSString stringWithFormat:@"算法%lu",self.allAlgorithms.count+1];
}

-(NSDictionary *)getAllAlgorithmsForUser:(SBUser *)user
{
    return [NSDictionary dictionaryWithDictionary:self.allAlgorithms];
}

// save algorithm, if nil, save selected algorithm
-(void)saveAlgorithm:(SBAlgorithm *)algorithm
{
    if (!algorithm) {
        algorithm = self.selectedAlgorithm;
    }
    if (!algorithm.uid) {
        NSString *uid = [self.dateFormatter stringFromDate:[NSDate date]];
        algorithm.uid = [uid stringByAppendingString:[NSString randomStringOfLength:5]];
    }
    [self.allAlgorithms setObject:algorithm forKey:algorithm.uid];
    algorithm.stockID = self.selectedStock.stockID;
    algorithm.stockName = self.selectedStock.name;
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:self.allAlgorithms.count];
    for (SBAlgorithm *a in [self.allAlgorithms allValues]) {
        [names addObject:a.name];
    }
    self.allAlgoName = [NSArray arrayWithArray:names];
    NSLog(@"all algos %@",self.allAlgoName);
    NSDictionary *archiveDict = [algorithm archiveToDict];
    //TODO: actually save the archived dict
}

-(void)removeAlgorithm:(NSString *)algorithmName
{
    
}

-(BOOL)algoNameExists:(NSString *)algoName
{
    return [self.allAlgoName containsObject:algoName];
}

#pragma mark Getters and Setters

-(NSMutableArray *)stocks
{
    if (!_stocks) {
        FMResultSet *result = [self.db executeQuery:@"select * from sse_stocks"];
        _stocks = [NSMutableArray arrayWithCapacity:400];
        while ([result next]) {
            SBStock *s = [SBStock new];
            s.name = [result resultDictionary][@"name"];
            s.stockID = [result resultDictionary][@"stock_id"];
            [_stocks addObject:s];
        }
    }
    return _stocks;
}

#pragma mark Image methods
-(NSURL *)getKChartImageURLForStock:(SBStock *)stock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sh%ld.gif",IMAGE_DAILY_K_URL,[stock.stockID longValue]]];
    return url;
}

-(NSURL *)getMACDImageURLForStock:(SBStock *)stock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sh%ld.gif",IMAGE_MACD_URL,[stock.stockID longValue]]];
    return url;
}

#pragma mark Stock Data methods

-(NSString *)getStockInfoURLStringForStock:(SBStock *)stock
{
    NSString *url = [NSString stringWithFormat:@"%@list=sh%ld",CURRENT_INFO_URL,[stock.stockID longValue]];
    return url;
}

#pragma mark CHCSVParserDelegate methods

-(void)parserDidBeginDocument:(CHCSVParser *)parser
{
    [self.db beginTransaction];
}

-(void)parserDidEndDocument:(CHCSVParser *)parser
{
    [self.db commit];
}

-(void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    [self.rowCache removeAllObjects];
}

-(void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    [self.db executeUpdate:@"insert or ignore into sse_stocks values (:name, :stock_id)",self.rowCache[0],self.rowCache[1]];
}

-(void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    self.rowCache[fieldIndex] = field;
}

#pragma mark helper methods

-(void)showErrorIfFailed:(BOOL)success
{
    if (!success) {
        NSLog(@"%@",[self.db lastErrorMessage]);
    }
}

@end
