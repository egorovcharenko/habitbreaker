//
//  InputProgressSuccess.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface InputProgressSuccessVC : BaseVC

@property (weak, nonatomic) IBOutlet UIImageView     *beltImage;
@property (weak, nonatomic) IBOutlet UIImageView     *nextBeltImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonNext;
@property (weak, nonatomic) IBOutlet UILabel         *howMuchToNextLevelLbl;
@property (weak, nonatomic) IBOutlet UILabel *actualPoints;

@end
