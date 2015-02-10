//
//  SBAlgoTableViewCell.m
//  StockBot
//
//  Created by Robert Guo on 3/18/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import "SBAlgoConditionTableViewCell.h"
#import "SBConstants.h"

@interface SBAlgoConditionTableViewCell()

@end


@implementation SBAlgoConditionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = BLACK_BG;
        
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ALGO_LIST_WIDTH-20, ALGO_ROW_HEIGHT)];
        self.bgView.backgroundColor = GREY_LIGHT;
        self.bgView.layer.borderWidth = 1;
        self.bgView.layer.borderColor = BLACK_BG.CGColor;
        [self.contentView addSubview:self.bgView];

        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ALGO_LIST_WIDTH - 240, ALGO_ROW_HEIGHT)];
        self.descriptionLabel.textColor = BLACK_BG;
        [self.contentView addSubview:self.descriptionLabel];

        // size is ignored
        self.algoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 100, 30, 0, 0)];
        [self.contentView addSubview:self.algoSwitch];
        
        self.algoSegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 170, 20, 150, ALGO_ROW_HEIGHT - 40)];
        self.algoSegmentedControl.tintColor = GREY_DARK;
        [self.contentView addSubview:self.algoSegmentedControl];
        
        self.numberSegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 170, 20, 100, ALGO_ROW_HEIGHT - 40)];
        UIFont *font = [UIFont boldSystemFontOfSize:22.0f];
        NSDictionary *attributes = @{NSFontAttributeName : font};
        [self.numberSegmentedControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
        [self.numberSegmentedControl insertSegmentWithTitle:@"—" atIndex:0 animated:NO];
        [self.numberSegmentedControl insertSegmentWithTitle:@"+" atIndex:1 animated:NO];
        self.numberSegmentedControl.tintColor = GREY_DARK;
        [self.contentView addSubview:self.numberSegmentedControl];

        self.numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 240, 20, 96, ALGO_ROW_HEIGHT - 40)];
//        self.numberTextField.backgroundColor = BLACK_BG;
        self.numberTextField.text = @"0";
        self.numberTextField.textAlignment = NSTextAlignmentCenter;
        self.numberTextField.layer.cornerRadius = 5.0f;
        self.numberTextField.delegate = self;
        [self.contentView addSubview:self.numberTextField];
        
        self.numberStepper = [[UIStepper alloc] initWithFrame:CGRectMake(ALGO_LIST_WIDTH - 128, 20, 96, ALGO_ROW_HEIGHT - 40)];
        self.numberStepper.tintColor = BLACK_BG;
        self.numberStepper.continuous = YES;
        self.numberStepper.minimumValue = 0;
        self.numberStepper.maximumValue = 10000000;
        self.numberStepper.stepValue = 100;
        self.numberStepper.value = 0;
        [self.contentView addSubview:self.numberStepper];
        
        [self.numberStepper addTarget:self action:@selector(numberStepperValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.algoSwitch.hidden = YES;
        self.algoSegmentedControl.hidden = YES;
        [self.algoSegmentedControl removeAllSegments];
        

    }
    
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TODO: check for integer and multiple of 100
    self.numberStepper.value = [textField.text floatValue];
    [self.numberTextField resignFirstResponder];    return YES;
}

-(void)numberStepperValueChanged:(UIStepper *)sender
{
    self.numberTextField.text = [NSString stringWithFormat:@"%.0f",sender.value];
}

-(void)resetCell
{
    // set cell to factory state without any buttons or toggles showing
    self.algoSwitch.hidden = YES;
    self.algoSegmentedControl.hidden = YES;
    [self.algoSegmentedControl removeAllSegments];
}

@end
