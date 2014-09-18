                //
//  SBInstructionsViewController.m
//  StockBot
//
//  Created by Robert Guo on 6/9/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBInstructionsViewController.h"

@interface SBInstructionsViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *gr;

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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.view.superview.layer.cornerRadius  = 10.0;
    self.view.superview.layer.masksToBounds = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加您的第一个算法";
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // doesn't work if placed in viewDidLoad
    // https://stackoverflow.com/questions/2623417/iphone-sdk-dismissing-modal-viewcontrollers-on-ipad-by-clicking-outside-of-it
    
    self.gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    self.gr.numberOfTapsRequired = 1;
    self.gr.cancelsTouchesInView = NO;
    [self.view.window addGestureRecognizer:self.gr];
}

-(void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            // Remove the recognizer first so its view.window is valid.
            [self.view.window removeGestureRecognizer:sender];
            [self.delegate instructionViewControllerDidDismiss:self];
        }
    }
}

-(IBAction)goButtonClicked:(id)sender
{
    [self.view.window removeGestureRecognizer:self.gr];
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
