//
//  SBLoginViewController.h
//  StockBot
//
//  Created by Robert Guo on 4/16/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface SBLoginViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet FXBlurView *inputBackground;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) IBOutlet UIButton *brokerSelectionButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@end
