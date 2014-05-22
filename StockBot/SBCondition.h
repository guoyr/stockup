//
//  SBAlgorithm.h
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBCondition : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *expandedDescription;

-(void)setupCell:(UITableViewCell *)cell AtIndex:(NSInteger)index;
-(int)numExpandedRows;
-(void)archive;
-(void)unarchive;

@end
