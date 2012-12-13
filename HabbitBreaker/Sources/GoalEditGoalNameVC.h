//
//  GoalEditGoalNameVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevNextVC.h"

@interface GoalEditGoalNameVC : PrevNextVC <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonNext;
@property (weak, nonatomic) IBOutlet UIImageView *checkingView;
@property (weak, nonatomic) IBOutlet UITextField *goalName;

- (IBAction)onTapAgree:(id)sender;
- (IBAction)onTapNotSure:(id)sender;
- (IBAction)onTapDisagree:(id)sender;

@end
