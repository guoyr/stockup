//
//  SBInstructionsViewController.h
//  StockBot
//
//  Created by Robert Guo on 6/9/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SBInstructionsViewController;

@protocol SBInstructionViewControllerDelegate <NSObject>

-(void)instructionViewControllerDidConfirm:(SBInstructionsViewController*)vc;

@end

@interface SBInstructionsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *goButton;
@property (nonatomic, weak) id<SBInstructionViewControllerDelegate> delegate;

@end
