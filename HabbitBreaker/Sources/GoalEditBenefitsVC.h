//
//  GoalEditBenefits.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevNextVC.h"
#import "SSTextView.h"

@class Goal;
@class SSTextView;


@interface GoalEditBenefitsVC : PrevNextVC <UITextViewDelegate>

@property (strong, nonatomic) Goal *goal;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollCanvas;

@property (weak, nonatomic) IBOutlet SSTextView *personalLifeBenefits;
@property (weak, nonatomic) IBOutlet SSTextView *myHealthBenefits;
@property (weak, nonatomic) IBOutlet SSTextView *myFinanceBenefits;
@property (weak, nonatomic) IBOutlet SSTextView *otherBenefits;

@end
