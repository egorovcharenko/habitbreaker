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
#import <Twitter/Twitter.h>
#import "FBHelper.h"

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

- (NSString*)messageToPost {
    NSString *message = [NSString stringWithFormat:@"Today, I promise that I will reach my goal: “%@” using HabitBreaker", self.goal.goalName];
    //NSLog(@"%@", message);
    return message;
}

- (NSString*)messageToPostTweet {
    NSString *message = [NSString stringWithFormat:@"Today, I promise that I will reach my goal: “%@” using #habitbreaker", self.goal.goalName];
    //NSLog(@"%@", message);
    return message;
}


- (IBAction)onFacebookTap:(id)sender {
    FBHelper *fbHelper = [FBHelper sharedInstance];
    
    [fbHelper postText:self.messageToPost];
}

- (IBAction)onTwitterTap:(id)sender {
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetVC = [TWTweetComposeViewController new];
        
        [tweetVC setInitialText:self.messageToPostTweet];
        
        [self presentViewController:tweetVC animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Tweet" message:@"Please ensure you have at least one Twitter account setup and have internet connectivity" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
