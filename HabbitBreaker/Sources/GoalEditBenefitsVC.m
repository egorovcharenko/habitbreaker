//
//  GoalEditBenefits.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "GoalEditBenefitsVC.h"
#import "Goal.h"
#import "SSTextView.h"
#import "CancellingPushSegue.h"

#import "LocalyticsSession.h"

@interface GoalEditBenefitsVC ()

@end

@implementation GoalEditBenefitsVC


- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    self.isVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isVisible = NO;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.personalLifeBenefits.text = self.goal.lifeBenefits;
    self.myFinanceBenefits.text    = self.goal.financeBenefits;
    self.myHealthBenefits.text     = self.goal.healthBenefits;
    self.otherBenefits.text        = self.goal.otherBenefits;
    
    self.personalLifeBenefits.placeholder = @"Example: I will spend more time with my family";
    self.myFinanceBenefits.placeholder    = @"Example: I will have more money to spend on holidays";
    self.myHealthBenefits.placeholder     = @"Example: I will live longer, will be able to do any biking";
    self.otherBenefits.placeholder        = @"";
    
    CGSize contentSize = self.scrollCanvas.contentSize;
    for (UIView *view in self.scrollCanvas.subviews) {
        contentSize.height = MAX(contentSize.height, view.frame.origin.y + view.frame.size.height);
        contentSize.width = MAX(contentSize.width, view.frame.origin.x + view.frame.size.width);
    }
    self.scrollCanvas.contentSize = contentSize;
    
    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Goal edit: goal benefits screen opened"];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Goal edit"];
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.personalLifeBenefits) {
        self.goal.lifeBenefits      = textView.text;
    }
    else if (textView == self.myHealthBenefits) {
        self.goal.healthBenefits    = textView.text;
    }
    else if (textView == self.myFinanceBenefits) {
        self.goal.financeBenefits   = textView.text;
    }
    else if (textView == self.otherBenefits) {
        self.goal.otherBenefits     = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (BOOL)checkFilledData {
    if (self.personalLifeBenefits.text.length > 0 &&
        self.myHealthBenefits.text.length > 0 &&
        self.myFinanceBenefits.text.length > 0)
    {
        // localytics
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.personalLifeBenefits.text, @"PersonalBenefits",
                                    self.myHealthBenefits.text, @"HealthBenefits",
                                    self.myFinanceBenefits.text, @"FinanceBenefits",
                                    nil];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Goal edit: entered goal beneftis:" attributes:dictionary];
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter all benefits - it will help you" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
