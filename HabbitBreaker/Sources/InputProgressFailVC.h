//
//  InputProgressFail.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface InputProgressFailVC : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *confirmationLbl;

- (IBAction)onPay:(id)sender;


@end
