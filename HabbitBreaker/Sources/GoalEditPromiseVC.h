//
//  GoalEditPromiseVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PrevNextVC.h"

@interface GoalEditPromiseVC : PrevNextVC <MFMailComposeViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *checkingView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollCanvas;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;

- (IBAction)onTapPrinted:(id)sender;
- (IBAction)onTapOtherWay:(id)sender;
- (IBAction)onSendEmail:(id)sender;

@end
