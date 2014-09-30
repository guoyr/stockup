//
//  SBStocksDataManager.m
//  StockBot
//
//  Created by Robert Guo on 2/27/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "SBDataManager.h"
#import "SBStock.h"
#import "SBAlgorithm.h"
#import "NSString+SBAdditions.h"
#import "AFNetworking.h"

@interface SBDataManager ()

@property(nonatomic, strong) FMDatabase *db;
@property(nonatomic, strong) NSMutableArray *rowCache; //caching csv data as we transfer it to fmdb
@property(nonatomic, strong) NSMutableDictionary *allAlgorithms;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SBDataManager

-(void)setAuthCookie:(NSString *)authCookie {
    [[NSUserDefaults standardUserDefaults] setObject:authCookie forKey:@"authCookie"];
    _authCookie = authCookie;
}

+ (id)sharedManager {
    static SBDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
    });
    return sharedMyManager;
}

- (SBAlgorithm *)selectedAlgorithm {
    if (!_selectedAlgorithm) {
        _selectedAlgorithm = [SBAlgorithm new];
    }
    return _selectedAlgorithm;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stockList" ofType:@"csv"];
        NSInputStream *pathStream = [NSInputStream inputStreamWithFileAtPath:path];
        //TODO: convert this to use synced data from the server in the future.

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [paths[0] stringByAppendingString:@"/stocks.db"];

        self.authCookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"authCookie"];
        
        self.brokerList = @[@"中信证券", @"民族证券", @"民生证券"];

        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateFormat:@"yy-MM-dd_HH:mm:ss"];

        self.db = [[FMDatabase alloc] initWithPath:dbPath];
        [self.db open];
        BOOL success = [self.db executeUpdate:@"create table if not exists sse_stocks(name nvarchar(256), stock_id integer)"];
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

- (NSString *)defaultAlgorithmName {
    return [NSString stringWithFormat:@"算法%lu", self.allAlgorithms.count + 1];
}

- (NSDictionary *)getAllAlgorithmsForUser:(SBUser *)user {
    return [NSDictionary dictionaryWithDictionary:self.allAlgorithms];
}

// save algorithm, if nil, save selected algorithm
- (void)saveAlgorithm {
    SBAlgorithm *algorithm = self.selectedAlgorithm;
    if (!algorithm.uid) {
        NSString *uid = [self.dateFormatter stringFromDate:[NSDate date]];
        algorithm.uid = [uid stringByAppendingString:[NSString randomStringOfLength:5]];
    }

    (self.allAlgorithms)[algorithm.uid] = algorithm;
    algorithm.stockID = self.selectedStock.stockID;
    algorithm.stockName = self.selectedStock.name;

    NSLog(@"%ld", (long)self.selectedAlgorithm.macdCondition.macdDirection);
    NSDictionary *archiveDict = [algorithm archiveToDict];

    NSLog(@"%@", archiveDict);

    //TODO: actually save the archived dict
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *params = @{@"Cookie": self.authCookie, @"algo":archiveDict, @"user_id": @"admin"};
    NSString *urlString = [NSString stringWithFormat: @"%@algo/upload/", SERVER_URL];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

- (void)removeAlgorithm:(NSString *)algorithmName {

}

#pragma mark Getters and Setters

- (NSMutableArray *)stocks {
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

#pragma mark CHCSVParserDelegate methods

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    [self.db beginTransaction];
}

- (void)parserDidEndDocument:(CHCSVParser *)parser {
    [self.db commit];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    [self.rowCache removeAllObjects];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [self.db executeUpdate:@"insert or ignore into sse_stocks values (:name, :stock_id)", self.rowCache[0], self.rowCache[1]];
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    self.rowCache[(NSUInteger) fieldIndex] = field;
}

#pragma mark helper methods

- (void)showErrorIfFailed:(BOOL)success {
    if (!success) {
        NSLog(@"%@", [self.db lastErrorMessage]);
    }
}

@end
