//
//  GoalEditPromiseVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "GoalEditPromiseVC.h"

typedef enum {
    Printed,
    OtherWay
} SelectionState;


@interface GoalEditPromiseVC ()
@property(nonatomic, unsafe_unretained)SelectionState selectionState;
@end

@implementation GoalEditPromiseVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        self.selectionState = Printed;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize contentSize = self.scrollCanvas.contentSize;
    for (UIView *view in self.scrollCanvas.subviews) {
        contentSize.height = MAX(contentSize.height, view.frame.origin.y + view.frame.size.height);
    }
    self.scrollCanvas.contentSize = contentSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCheckingView:nil];
    [self setScrollCanvas:nil];
    [self setEmailTxt:nil];
    [super viewDidUnload];
}

- (void)selectItem:(UIView*)item {
    CGRect checkingViewFrame = self.checkingView.frame;
    checkingViewFrame.origin = CGPointMake(7, 6);
    self.checkingView.frame = checkingViewFrame;
    
    [item addSubview:self.checkingView];
}


- (void)viewDidAppear:(BOOL)animated {
    self.isVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isVisible = NO;
}

- (BOOL)checkFilledData {
    return YES;
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
        CGRect extendedFrame = self.view.frame;
        extendedFrame.size.height += [[note.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.view.frame = extendedFrame;
        } completion:nil];
    }
}

- (IBAction)onTapPrinted:(id)sender {
    [self selectItem:sender];
    self.selectionState = Printed;
}

- (IBAction)onTapOtherWay:(id)sender {
    [self selectItem:sender];
    self.selectionState = OtherWay;
}

- (void)scrollToEditingView:(UIView*)editingView {
    CGRect rectToScroll = editingView.frame;
    
    [self.scrollCanvas scrollRectToVisible:rectToScroll animated:YES];
    [self.scrollCanvas setContentOffset:CGPointMake(0, rectToScroll.origin.y - 5) animated:YES];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollToEditingView:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onSendEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setMessageBody:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/tml4/strict.dtd\"><html><head>  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">  <meta http-equiv=\"Content-Style-Type\" content=\"text/css\">  <title></title>  <meta name=\"Generator\" content=\"Cocoa HTML Writer\">  <meta name=\"CocoaVersion\" content=\"1138.51\">  <style type=\"text/css\">      p.p0 {} p.p1 {} p.p2 {}  </style></head><body><p class=\"p0\"><center>PROMISE TO MYSELF</center></p><p class=\"p1\">Today, I promise to myself that I am totally devoted to reaching my goal: \"%@\"</p><p class=\"p1\">It will bring me the following benefits:</p><p class=\"p1\"><b>Financial: </b>%@</p><p class=\"p1\"><b>For my health:</b> %@</p><p class=\"p1\"><b>For personal life:</b> %@</p><p class=\"p1\"><b>Other benefits:</b> %@</p></body></html>" isHTML:YES];
        [mailViewController setSubject:@"PROMISE TO MYSELF"];
        [mailViewController setToRecipients:@[self.emailTxt.text]];
        
        [self presentModalViewController:mailViewController animated:YES];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"%d", result == MFMailComposeResultSent);
    NSLog(@"%@", error);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
