//
//  SBAlgorithm.m
//  StockBot
//
//  Created by Robert Guo on 4/30/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBCondition.h"
#import "SBAlgouCustomizeTableViewCell.h"
#import "SBConstants.h"
@implementation SBCondition

-(void)setupCell:(SBAlgouCustomizeTableViewCell *)cell AtIndex:(NSInteger)index
{
    cell.descriptionLabel.hidden = NO;
}

-(int)numExpandedRows
{   
    return 0;
}

-(void)archive
{
    
}

-(void)unarchive
{
    
}

@end
