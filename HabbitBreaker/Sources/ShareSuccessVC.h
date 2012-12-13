//
//  ShareSuccessVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"


@interface ShareSuccessVC : BaseVC <UITextViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonNext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollCanvas;

- (IBAction)onFacebookTap:(id)sender;
- (IBAction)onTwitterTap:(id)sender;
- (IBAction)onSaveTap:(id)sender;
- (IBAction)onFinishTap:(id)sender;

@end
