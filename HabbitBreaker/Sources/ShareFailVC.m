//
//  ShareFailVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "ShareFailVC.h"
#import "App.h"
#import "TabbarVC.h"
#import "Result.h"
#import "Goal.h"
#import "TabbarVC.h"
#import <Twitter/Twitter.h>
#import "FBHelper.h"
#import "AppDelegate.h"

@interface ShareFailVC ()
@property(nonatomic, unsafe_unretained)BOOL isVisible;
@end

@implementation ShareFailVC


- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
        self.isVisible = NO;
    }
    
    return self;
}

- (void)keyboardDidShow:(NSNotification*)note {
    if (self.isVisible) {
        CGRect shrinkedFrame = self.scrollCanvas.frame;
        shrinkedFrame.size.height -= [[note.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
        self.scrollCanvas.frame = shrinkedFrame;
    }
}

- (void)keyboardWillHide:(NSNotification*)note {
    if (self.isVisible) {
        CGRect extendedFrame = self.scrollCanvas.frame;
        extendedFrame.size.height += [[note.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.scrollCanvas.frame = extendedFrame;
        } completion:nil];
    }
}
- (void)scrollToEditingView:(UIView*)editingView {
    CGRect rectToScroll = editingView.frame;
    [self.scrollCanvas scrollRectToVisible:rectToScroll animated:YES];
    [self.scrollCanvas setContentOffset:CGPointMake(0, rectToScroll.origin.y - 5) animated:YES];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self scrollToEditingView:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *previousBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [previousBtnView addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [previousBtnView setBackgroundImage:[UIImage imageNamed:@"GE_Back_Button.png"] forState:UIControlStateNormal];
        [previousBtnView setFrame:CGRectMake(0, 0, 70, 30)];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:previousBtnView];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        self.navigationItem.hidesBackButton = YES;
    }
    
    CGSize contentSize = self.scrollCanvas.contentSize;
    for (UIView *view in self.scrollCanvas.subviews) {
        contentSize.height = MAX(contentSize.height, view.frame.origin.y + view.frame.size.height);
        contentSize.width = MAX(contentSize.width, view.frame.origin.x + view.frame.size.width);
    }
    self.scrollCanvas.contentSize = contentSize;
}

- (void)viewWillAppear:(BOOL)animated {
    self.isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.isVisible = NO;
}

- (void)viewDidUnload {
    [self setScrollCanvas:nil];
    [super viewDidUnload];
}

- (NSString*)messageToPost {
    Goal *theGoal = [App sharedApp].goals.lastObject;
    NSString *message = nil;
    if (self.comment.text.length != 0) {
        message = [NSString stringWithFormat:@"%@ - today I was not up to my high standarts in quest for “%@>” using HabitBreaker, but it will help me to move closer to my goal!",
                   self.comment.text,
                   theGoal.goalName];
    } else {
        message = [NSString stringWithFormat:@"Today I was not up to my high standarts in quest for “%@” using HabitBreaker, but it will help me to move closer to my goal!",
                   theGoal.goalName];
    }
    
    return message;
}

- (NSString*)messageToPostTweet {
    Goal *theGoal = [App sharedApp].goals.lastObject;
    NSString *message = nil;
    if (self.comment.text.length != 0) {
        message = [NSString stringWithFormat:@"%@ - today I was not up to my high standarts in quest for “%@>” using #habitbreaker, but it will help me to move closer to my goal!",
                   self.comment.text,
                   theGoal.goalName];
    } else {
        message = [NSString stringWithFormat:@"Today I was not up to my high standarts in quest for “%@” using #habitbreaker, but it will help me to move closer to my goal!",
                   theGoal.goalName];
    }
    
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

- (IBAction)onSaveTap:(id)sender {
    Goal   *goal   = [App sharedApp].goals.lastObject;
    Result *result = goal.progressHistory.lastObject;
    result.comment = self.comment.text;
    [[App sharedApp] synchronize];
    
    UINavigationController *navigationVC = self.navigationController;
    [navigationVC popToRootViewControllerAnimated:YES];
    TabbarVC *tabbar = (TabbarVC*)navigationVC.topViewController;
    tabbar.selectedIndex = 0;
}

- (IBAction)onFinishTap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    TabbarVC *tabbar = self.navigationController.viewControllers.lastObject;
    tabbar.selectedIndex = 0;
}

@end
