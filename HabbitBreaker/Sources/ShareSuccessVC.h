//
//  ShareSuccessVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"


@interface ShareSuccessVC : BaseVC <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonNext;

- (IBAction)onFacebookTap:(id)sender;
- (IBAction)onTwitterTap:(id)sender;
- (IBAction)onSaveTap:(id)sender;
- (IBAction)onFinishTap:(id)sender;

@end
