//
//  GoalEditCriteria.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "GoalEditCriteriaVC.h"
#import "Goal.h"

#import "LocalyticsSession.h"

@implementation GoalEditCriteriaVC

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.successCriteria.placeholder = @"Example: I have not eaten sweets after 3pm.";
    self.failCriteria.placeholder    = @"Example: I have eaten at least one sweet thing after 3pm.";
    
    self.successCriteria.text = self.goal.successCriteria;
    self.failCriteria.text    = self.goal.failCriteria;
    
    CGSize contentSize = self.scrollCanvas.contentSize;
    for (UIView *view in self.scrollCanvas.subviews) {
        contentSize.height = MAX(contentSize.height, view.frame.origin.y + view.frame.size.height);
        contentSize.width = MAX(contentSize.width, view.frame.origin.x + view.frame.size.width);
        
//        NSLog(@"%@:  width: %f, height: %f, origin.x: %f, origin.y: %f\n\n\n", view.class, view.frame.size.width, view.frame.size.height, view.frame.origin.x, view.frame.origin.y);
//        
//        if (fabs(view.frame.origin.y - 396) < 1) {
//            [view setBackgroundColor:[UIColor orangeColor]];
//            view.frame = CGRectMake(0, 0, 100, 100);
//            [view.superview bringSubviewToFront:view];
//            [self.view addSubview:view];
//        }
    }
    
    self.scrollCanvas.contentSize = contentSize;
    
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Goal edit: criteria screen opened"];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Goal edit criteria screen"];
}

- (void)viewDidAppear:(BOOL)animated {
    self.isVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.successCriteria) {
        self.goal.successCriteria  = textView.text;
    }
    else if (textView == self.failCriteria) {
        self.goal.failCriteria    = textView.text;
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
    if (self.failCriteria.text.length > 0 &&
        self.successCriteria.text.length > 0)
    {
        // localytics
        NSDictionary *dictionary =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.failCriteria.text, @"FailCriteria",
         self.successCriteria.text, @"SuccessCriteria",
         nil];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Goal edit: entered criteria:" attributes:dictionary];
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter all criterias" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
