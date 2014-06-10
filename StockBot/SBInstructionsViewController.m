//
//  SBInstructionsViewController.m
//  StockBot
//
//  Created by Robert Guo on 6/9/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBInstructionsViewController.h"

@interface SBInstructionsViewController ()

@end

@implementation SBInstructionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加您的第一个算法";
}

-(IBAction)goButtonClicked:(id)sender
{
    [self.delegate instructionViewControllerDidConfirm:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
