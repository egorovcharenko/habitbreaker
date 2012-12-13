//
//  GoalEditCriteria.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevNextVC.h"
#import "SSTextView.h"

@class Goal;

@interface GoalEditCriteriaVC : PrevNextVC <UITextViewDelegate>

@property(nonatomic, strong)Goal *goal;

@property(nonatomic, strong)IBOutlet SSTextView     *successCriteria;
@property(nonatomic, strong)IBOutlet SSTextView     *failCriteria;
@property(nonatomic, strong)IBOutlet UIScrollView   *scrollCanvas;

@end
