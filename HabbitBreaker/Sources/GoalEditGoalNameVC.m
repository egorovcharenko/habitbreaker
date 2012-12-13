//
//  GoalEditGoalNameVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "GoalEditGoalNameVC.h"
#import "CancellingPushSegue.h"
#import "App.h"
#import "Goal.h"

typedef enum {
    Agree,
    NotSure,
    Disagree
} SelectionState;

@interface GoalEditGoalNameVC ()
@property(nonatomic, unsafe_unretained)SelectionState selectionState;
@end

@implementation GoalEditGoalNameVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionState = NotSure;
        self.goal = [App sharedApp].goals.lastObject;
        if (self.goal == nil) {
            self.goal = [Goal new];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.goalName.text = self.goal.goalName;
}

- (void)dismissMe:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapNext:(id)sender {
    
}

- (void)viewDidUnload {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)selectItem:(UIView*)item {
    CGRect checkingViewFrame = self.checkingView.frame;
    checkingViewFrame.origin = CGPointMake(11, 9);
    self.checkingView.frame = checkingViewFrame;
    
    [item addSubview:self.checkingView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.goal.goalName  = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)checkFilledData {
    if (self.goalName.text.length > 0) {
        if (self.selectionState == Agree) {
            return YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You should accept that you want to achieve it" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You should fill the name field" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (IBAction)onTapAgree:(id)sender {
    [self selectItem:sender];
    self.selectionState = Agree;
}

- (IBAction)onTapNotSure:(id)sender {
    [self selectItem:sender];
    self.selectionState = NotSure;
}

- (IBAction)onTapDisagree:(id)sender {
    [self selectItem:sender];
    self.selectionState = Disagree;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end