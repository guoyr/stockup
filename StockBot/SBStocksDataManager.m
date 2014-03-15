//
//  SBStocksDataManager.m
//  StockBot
//
//  Created by Robert Guo on 2/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "SBStocksDataManager.h"
#import "SBStock.h"
#import "SBConstants.h"

@interface SBStocksDataManager()

@property (nonatomic, assign) NSUInteger curLine;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *rowCache; //caching csv data as we transfer it to fmdb

@end

@implementation SBStocksDataManager

+ (id)sharedManager {
    static SBStocksDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(id)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stockList" ofType:@"csv"];
        NSInputStream *pathStream = [NSInputStream inputStreamWithFileAtPath:path];
        //TODO: convert this to use synced data from the server in the future.
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [paths[0] stringByAppendingString:@"stocks.db"];
        
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
    }
    
    return self;
}

#pragma mark Getters and Setters

-(NSMutableArray *)stocks
{
    if (!_stocks) {
        FMResultSet *result = [self.db executeQuery:@"select * from sse_stocks"];
        _stocks = [NSMutableArray arrayWithCapacity:400];
        while ([result next]) {
            SBStock *s = [[SBStock alloc] init];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sh%d.gif",IMAGE_DAILY_K_URL,[stock.stockID integerValue]]];
    return url;
}

-(NSURL *)getMACDImageURLForStock:(SBStock *)stock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sh%d.gif",IMAGE_MACD_URL,[stock.stockID integerValue]]];
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
