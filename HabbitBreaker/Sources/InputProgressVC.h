//
//  InputProgressVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface InputProgressVC : BaseVC <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *gaveInLbl;
@property (weak, nonatomic) IBOutlet UITextView *resistedLbl;

- (IBAction)gotoFailVC:(id)sender;
- (IBAction)gotoSuccessVC:(id)sender;

@end
