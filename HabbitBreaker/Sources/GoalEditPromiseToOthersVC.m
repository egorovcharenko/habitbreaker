//
//  GoalEditPromiseToOthersVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "GoalEditPromiseToOthersVC.h"
#import "App.h"
#import "Goal.h"

@interface GoalEditPromiseToOthersVC ()

@end

@implementation GoalEditPromiseToOthersVC


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIButton *finishButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton addTarget:self.barButtonNext.target action:self.barButtonNext.action forControlEvents:UIControlEventTouchUpInside];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"GE_Finish_Button.png"] forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(0, 0, 90, 30)];
    
    self.barButtonNext.customView = finishButton;
}


- (IBAction)onFinish:(id)sender {
    [[App sharedApp] addGoal:self.goal];
    [self.goal start];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
