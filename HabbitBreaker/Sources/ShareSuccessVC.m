//
//  ShareSuccessVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "ShareSuccessVC.h"
#import "App.h"
#import "TabbarVC.h"
#import "Result.h"
#import "Goal.h"

@interface ShareSuccessVC ()

@end

@implementation ShareSuccessVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *finishButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton addTarget:self.barButtonNext.target action:self.barButtonNext.action forControlEvents:UIControlEventTouchUpInside];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"GE_Finish_Button.png"] forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(0, 0, 90, 30)];
    
    self.barButtonNext.customView = finishButton;
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *previousBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [previousBtnView addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [previousBtnView setBackgroundImage:[UIImage imageNamed:@"GE_Back_Button.png"] forState:UIControlStateNormal];
        [previousBtnView setFrame:CGRectMake(0, 0, 70, 30)];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:previousBtnView];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onFacebookTap:(id)sender {
    
}

- (IBAction)onTwitterTap:(id)sender {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)onSaveTap:(id)sender {
    [[[App sharedApp].goals.lastObject progressHistory].lastObject setComment:self.comment.text];
    [[App sharedApp] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onFinishTap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
